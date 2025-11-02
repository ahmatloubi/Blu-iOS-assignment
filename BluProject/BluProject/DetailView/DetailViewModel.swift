//
//  DetailViewModel.swift
//  BluProject
//
//  Created by Amir Hossein on 01/11/2025.
//

import Foundation
import BluProjectModel
import Factory

class DetailViewModel: ObservableObject {
    
    @Injected(\.favoriteTransfersService) var favoriteTransfersService
    
    init(rowViewModel: HomePageRowViewModel) {
        self.isFavorite = rowViewModel.isFavorite
        self.transfer = rowViewModel.transfer
        setupPublishers()
    }
    
    @Published var isFavorite: Bool
    @Published var transfer: Transfer
    @Published var amount: String = ""
    @Published var lastTransferDate: String = "-"
    @Published var isErrorAlertPresented: Bool = false
    
    private func setupPublishers() {
        $transfer
            .map(\.moreInfo)
            .map(\.totalTransfer)
            .map { self.getCurrency(amount: $0) }
            .assign(to: &$amount)
        
        $transfer
            .map(\.lastTransfer)
            .map { self.getDateString(date: $0) }
            .assign(to: &$lastTransferDate)
    }
    
    func onTapFavoriteButton() {
        do {
            if isFavorite {
                try favoriteTransfersService.removeFavoriteTransfer(transfer)
            } else {
                try favoriteTransfersService.addFavoriteTransfer(transfer)
            }
            isFavorite.toggle()
        } catch (let error) {
            print("Error happened: \(error)")
            isErrorAlertPresented = true
        }
    }
    
    private func getCurrency(amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = .current
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
    
    private func getDateString(date: Date?) -> String {
        guard let date else { return "-" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
}
