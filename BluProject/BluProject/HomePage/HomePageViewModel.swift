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
    
    init(transferService: TransfersServiceProtocol) {
        self.transferService = transferService
        setupPublishers()
    }
    
    @Published var transfers: [Transfer] = []
    @Published var state: HomePageState = .loading
    @Published var favoriteTransfers: [Transfer] = []
    @Published var canLoadMore: Bool = true
    
    private var isLoading: Bool = false
    
    private var page: Int = 1
    
    private var pageSize: Int = 10
    
    private func setupPublishers() {
        $transfers
            .map { $0.isEmpty }
            .map { $0 ? HomePageState.empty : .loaded }
            .assign(to: &$state)
        
        $transfers
            .map(\.count)
            .map({$0.isMultiple(of: self.pageSize)})
            .assign(to: &$canLoadMore)
    }
    
    func onAppear() {
        updateView {
            self.state = .loading
        }
        
        Task {
            await loadAtPage(1)
        }
        
    }
    
    func loadAtPage(_ page: Int) async {
        guard !isLoading else { return }
        isLoading = true
        self.page = page
        do {
            let transfers = try await transferService.fetchContacts(page: page)
            updateView {
                if page <= 1 {
                    self.transfers = transfers
                } else {
                    self.transfers.append(contentsOf: transfers)
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
