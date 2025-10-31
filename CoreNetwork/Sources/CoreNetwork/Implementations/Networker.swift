import Alamofire
import Foundation

public class Networker: NetworkerProtocol {
    let errorDecodable: ErrorDecodableProtocol?
    
    public init(errorDecodable: ErrorDecodableProtocol? = nil) {
        self.errorDecodable = errorDecodable
    }
    
    public func fetchRequest<REQUEST, RESPONSE>(_ request: NetworkRequest<REQUEST, RESPONSE>) async throws -> RESPONSE where REQUEST : Encodable, RESPONSE : Decodable & Sendable {
        let dataRequest = AF.request(request.url,
                                 method: request.method.httpMethod,
                                 parameters: request.parameters?.toDictionary,
                                 encoding: URLEncoding.queryString)
        
        let response = await dataRequest.serializingDecodable(RESPONSE.self, decoder: request.decoder).response
        
        switch response.result {
        case .success(let value):
            return value
        case .failure(let afError):
            print("Error received from AlamoFire: \(afError)")
            if let data = response.data {
                if let error = errorDecodable?.decodeError(data) {
                    throw error
                }
            } else if afError._code == NSURLErrorTimedOut  {
                throw NetworkError.timeOut
            }
            throw NetworkError.network
        }
        
    }
}
