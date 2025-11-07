//
//  TransferViewModel.swift
//  Blu-Assignment-UIKit
//
//  Created by Amir Hossein on 07/11/2025.
//

import Foundation
import BluProjectModel
import Factory



@MainActor
final class TransferDetailViewModel: ObservableObject {
    
    @Injected(\.favoriteTransfersService) private var favoriteTransfersService
    
    private let transfer: Transfer
    
    @Published var isFavorite: Bool
    @Published var fullName: String = ""
    @Published var cardNumber: String = ""
    @Published var avatarURL: String?
    
    init(transfer: Transfer, isFavorite: Bool) {
        self.transfer = transfer
        self.isFavorite = isFavorite
        setupInitialData()
        
    }
    
    private func setupInitialData() {
        fullName = transfer.person.fullName
        cardNumber = transfer.card.cardNumber
        avatarURL = transfer.person.avatar
    }
   
    
    func toggleFavorite() async {
        do {
            if isFavorite {
                try favoriteTransfersService.removeFavoriteTransfer(transfer)
                isFavorite = false
            } else {
                try favoriteTransfersService.addFavoriteTransfer(transfer)
                isFavorite = true
            }
        } catch {
            print("Failed to toggle favorite: \(error)")
        }
    }
}

