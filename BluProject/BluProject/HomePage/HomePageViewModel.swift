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
    @Published var searchText: String = ""
    @Published var isSearhing: Bool = false
    @Published var isRefreshing: Bool = false
    
    private var isLoading: Bool = false
    
    private var lastRowViewModels: [HomePageRowViewModel] = []
    private var lastFavoriteTransfer: [Transfer] = []
    
    private var page: Int = 1
    
    private var pageSize: Int = 10
    
    private func setupPublishers() {
        $rowViewModels
            .map { $0.isEmpty }
            .map { ($0 && self.isSearhing) ? HomePageState.empty : .loaded }
            .assign(to: &$state)
        
        $rowViewModels
            .map(\.count)
            .map({$0.isMultiple(of: self.pageSize)})
            .assign(to: &$canLoadMore)
        
        $searchText
            .map { searchText in
                guard !searchText.isEmpty else { return self.lastRowViewModels }
                let filteredRows = self.lastRowViewModels.filter { $0.transfer.person.fullName.lowercased().contains(searchText.lowercased()) }
                return filteredRows
            }
            .assign(to: &$rowViewModels)
        
        $searchText
            .map { searchText in
                guard !searchText.isEmpty else { return self.lastFavoriteTransfer }
                let filteredRows = self.lastFavoriteTransfer.filter { $0.person.fullName.contains(searchText) }
                return filteredRows
            }
            .assign(to: &$favoriteTransfers)
        
        $isSearhing
            .map { !$0 }
            .assign(to: &$canLoadMore)
    }
    
    func onAppear() {
        updateView {
            self.state = .loading
            self.fetchFavoriteTransfers()
            self.isSearhing = false
        }
        
        Task {
            await loadAtPage(1)
        }
        
    }
    
    
    func fetchFavoriteTransfers() {
        do {
            favoriteTransfers = try favoriteTransferService.getFavoriteTransfers()
            lastFavoriteTransfer = favoriteTransfers
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
            lastRowViewModels = rowViewModels
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
        updateView {
            self.searchText = ""
        }
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
