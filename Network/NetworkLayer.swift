//
//  RequestExecuter.swift
//
//  Created by Ashish on 07/05/2023.
//

import Foundation
import Combine

protocol NetworkProtocol {
    func execute<T>(request: T) -> AnyPublisher<T.Response, Error> where T: NetworkRequest
}

final class NetworkLayer: NetworkProtocol {
    
    private let session: URLSession
    
    init(networkConfiguration: URLSessionConfiguration = URLSessionConfiguration.default) {
        self.session = URLSession(configuration: networkConfiguration)
    }
    
    func execute<T>(request: T) -> AnyPublisher<T.Response, Error> where T : NetworkRequest {
        
        do {
            let request = try request.asUrlRequest()
         let dataTaskPublisher = session.dataTaskPublisher(for: request)
        
        return dataTaskPublisher
            .tryMap({ (data: Data, response: URLResponse) -> T.Response in
 
                guard let response = response as? HTTPURLResponse,
                        (200...300).contains(response.statusCode) else {
                    throw self.parseAPIErrors(response: response as! HTTPURLResponse)
                }
                
                do {
                    let response = try JSONDecoder().decode(T.Response.self, from: data)
                    debugPrint("RESPONSE:--\(response)")
                    return response
                } catch (let err) {
                    throw err
                }
            })
            .mapError({ error in
                debugPrint("ERROR:--\(error)")
                if error is ApiError {
                    return error
                } else if error is DecodingError {
                    return ParsingError.parserError(error: error.localizedDescription)
                } else {
                    return error
                }
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        } catch (let err) {
            return Fail(error: err).eraseToAnyPublisher()
        }
    }
    
    // Handle Multiple Errors from the API
    private func parseAPIErrors(response: HTTPURLResponse) -> Error {

        switch response.statusCode {
        case 400: return ApiError.badRequest
        default: return ApiError.invalidResponse
            
        }
    }
}
