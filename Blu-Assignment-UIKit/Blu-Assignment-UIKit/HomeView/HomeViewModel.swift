//
//  HomeViewModel.swift
//  Blu-Assignment-UIKit
//
//  Created by Amir Hossein on 07/11/2025.
//

import Foundation
import Factory
import BluProjectModel

@MainActor
final class HomeViewModel: ObservableObject {
    
    @Injected(\.transferServices) private var transferServices
    @Injected(\.favoriteTransfersService) private var favoriteTransfersService
    
    @Published private(set) var transferRowViewModels: [TransferRowViewModel] = []
    @Published private(set) var isLoading = false
    @Published private(set) var hasMorePages = true
    @Published private(set) var favoriteTransfers: [Transfer] = []

    private var currentPage = 1
    
    func initialLoad() {
        currentPage = 1
        hasMorePages = true
        loadPage(page: currentPage, isRefreshing: false)
    }
    
    func refresh() {
        currentPage = 1
        hasMorePages = true
        loadPage(page: currentPage, isRefreshing: true)
    }
    
    func loadNextPageIfNeeded(currentIndex: Int) {
        let thresholdIndex = transferRowViewModels.count - 3
        if currentIndex == thresholdIndex && !isLoading && hasMorePages {
            currentPage += 1
            loadPage(page: currentPage, isRefreshing: false)
        }
    }
    
    private func loadPage(page: Int, isRefreshing: Bool) {
        guard !isLoading && hasMorePages else { return }
        isLoading = true
        
        Task {
            do {
                let newTransfers = try await transferServices.fetchContacts(page: page)
                
                if page == 1 {
                    favoriteTransfers = try favoriteTransfersService.getFavoriteTransfers()
                }
                
                let newViewModels = newTransfers.map { transfer in
                    TransferRowViewModel(
                        isFavorite: favoriteTransfers.contains(where: { $0.id == transfer.id }),
                        transfer: transfer
                    )
                }
                
                if isRefreshing {
                    transferRowViewModels = newViewModels
                } else {
                    transferRowViewModels.append(contentsOf: newViewModels)
                }
                
                if newTransfers.isEmpty {
                    hasMorePages = false
                }
            } catch {
                print("Error fetching page \(page): \(error)")
            }
            isLoading = false
        }
    }
}
