//
//  HomePageRowViewModel.swift
//  BluProject
//
//  Created by Amir Hossein on 01/11/2025.
//

import Foundation
import BluProjectModel

struct HomePageRowViewModel: Identifiable {
    let isFavorite: Bool
    let transfer: Transfer
    
    var id: Int {
        transfer.id
    }
}
