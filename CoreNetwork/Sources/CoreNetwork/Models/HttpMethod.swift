//
//  File.swift
//  CoreNetwork
//
//  Created by Amir Hossein on 27/10/2025.
//

import Foundation
import Alamofire

public enum HttpMethod {
    case post, get, put, delete
    
    var httpMethod: HTTPMethod {
        switch self {
        case .post:
            return .post
        case .get:
            return .get
        case .put:
            return .put
        case .delete:
            return .delete
        }
    }
}
