//
//  HomePageViewModel.swift
//  BluProject
//
//  Created by Amir Hossein on 27/10/2025.
//

import Foundation
import Factory
import BluProjectModel

class HomePageViewModel: ObservableObject {
    private let transferService: TransfersServiceProtocol
    private let favoriteTransferService: FavoriteTransfersServiceProtocol
    
    init(transferService: TransfersServiceProtocol, favoriteTransferService: FavoriteTransfersServiceProtocol) {
        self.transferService = transferService
        self.favoriteTransferService = favoriteTransferService
        setupPublishers()
    }
    
    @Published var rowViewModels: [HomePageRowViewModel] = []
    @Published var state: HomePageState = .loading
    @Published var favoriteTransfers: [Transfer] = []
    @Published var canLoadMore: Bool = true
    
    private var isLoading: Bool = false
    
    private var page: Int = 1
    
    private var pageSize: Int = 10
    
    private func setupPublishers() {
        $rowViewModels
            .map { $0.isEmpty }
            .map { $0 ? HomePageState.empty : .loaded }
            .assign(to: &$state)
        
        $rowViewModels
            .map(\.count)
            .map({$0.isMultiple(of: self.pageSize)})
            .assign(to: &$canLoadMore)
    }
    
    func onAppear() {
        updateView {
            self.state = .loading
            self.fetchFavoriteTransfers()
        }
        
        Task {
            await loadAtPage(1)
        }
        
    }
    
    
    func fetchFavoriteTransfers() {
        do {
            favoriteTransfers = try favoriteTransferService.getFavoriteTransfers()
        } catch {
            updateView {
                self.state = .error
            }
        }
    }
    
    func loadAtPage(_ page: Int) async {
        guard !isLoading else { return }
        isLoading = true
        self.page = page
        do {
            let transfers = try await transferService.fetchContacts(page: page)
            let rowViewModels = transfers.map { transfer in
                return HomePageRowViewModel(isFavorite: favoriteTransfers.contains(where: {$0.id == transfer.id }), transfer: transfer)
            }
            updateView {
                if page == 1 {
                    self.rowViewModels = rowViewModels
                } else {
                    self.rowViewModels.append(contentsOf: rowViewModels)
                }
            }
        } catch {
            updateView {
                self.state = .error
            }
        }
        isLoading = false
    }
    
    func updateView(_ update: @escaping () -> Void) {
        Task { @MainActor in
            update()
        }
    }
   
    func refresh() {
        Task {
            await loadAtPage(1)
        }
    }
    
    func loadMore() {
        Task {
            await loadAtPage(page + 1)
        }
    }
}
