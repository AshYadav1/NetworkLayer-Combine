//
//  AppNetworking.swift
//
//  Created by Ashish on 07/05/2023.
//

import Foundation

typealias ApiHeaders = [String: String]

protocol NetworkRequest {
    associatedtype Response: Decodable
    
    var endPoint: APiEndPoints { get set }
    var method: HTTPMethod { get set }
    var parameters: Encodable? { get set }
    var headers: ApiHeaders { get set }
    func asUrlRequest() throws -> URLRequest
}

extension NetworkRequest {
    
    func asUrlRequest() throws -> URLRequest {
        
        guard let url = self.getUrl else {
            throw ApiError.incorrectURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = 60 // Api time Out Interval
        request.allHTTPHeaderFields = headers
        
        if let params = parameters {
            do {
                request.httpBody = try JSONEncoder().encode(params.self)
            } catch (let error) {
                throw ApiError.requestEncodingError(error: error.localizedDescription)
            }
        }
        return request
    }
    
    private var getUrl: URL? {
        let baseUrl = ApiConstants.baseUrl + "/" + endPoint.value
        return URL(string: baseUrl)
    }
}
