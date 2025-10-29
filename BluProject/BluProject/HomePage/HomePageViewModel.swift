//
//  HomePageViewModel.swift
//  BluProject
//
//  Created by Amir Hossein on 27/10/2025.
//

import Foundation
import Factory
import BluProjectModel

struct HomePageState2 {
    
}

class HomePageViewModel: ObservableObject {
    //useCase
    
    @Published var contacts: [Contact] = [
        .init(person: .init(name: "Amir")),
        .init(person: .init(name: "Ali")),
        .init(person: .init(name: "Reza")),
    ]
    @Published var state: HomePageState = .loading
    @Published var favoriteContacts: [Contact] = [
        .init(person: .init(name: "Amir")),
        .init(person: .init(name: "Ali")),
        .init(person: .init(name: "Reza")),
    ]
    
    
    func viewDidAppear() {
        //useCase.fetchList(page: 1)
    }
    
    func loadContacts() {
    }
    
    func refresh() {
        
    }
}
