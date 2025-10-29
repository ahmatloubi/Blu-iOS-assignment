//
//  Container.swift
//  BluProject
//
//  Created by Amir Hossein on 27/10/2025.
//

import Foundation
import Factory

extension Container {
    var homePageViewModel: Factory<HomePageViewModel> {
        self {
            HomePageViewModel()
        }
    }
}
