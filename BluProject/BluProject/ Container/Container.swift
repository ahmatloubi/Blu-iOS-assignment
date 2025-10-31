//
//  Container.swift
//  BluProject
//
//  Created by Amir Hossein on 27/10/2025.
//

import Foundation
import Factory
import BluProjectModel
import CoreNetwork

extension Container {
    var homePageViewModel: Factory<HomePageViewModel> {
        self {
            HomePageViewModel(transferService: self.transferServices())
        }
    }
    
    var transferServices: Factory<TransfersServiceProtocol> {
        self {
            TransfersService(networker: self.networkerProtocol(), urlBuilder: self.urlBuilder())
        }
    }
    
    var networkerProtocol: Factory<NetworkerProtocol> {
        self {
            Networker(errorDecodable: self.errorDecodable())
        }
    }
    
    var urlBuilder: Factory<any URLBuilderProtocol> {
        self {
            URLBuilder(baseURL: "6e7abd2e-3e39-4d56-8b4a-915a4d4fe062.mock.pstmn.io")
        }
    }
    
    var errorDecodable: Factory<ErrorDecodableProtocol> {
        self {
            ErrorDecodable()
        }
    }
}
