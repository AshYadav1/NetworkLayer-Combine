//
//  ApiError.swift
//
//  Created by Ashish on 07/05/2023.
//

import Foundation

enum ApiError: Error, LocalizedError {
    
    case invalidResponse
    case badRequest
    case incorrectURL
    case requestEncodingError(error: String)
    
    var errorDescription: String {
        
        switch self {
        case .invalidResponse:
            return "Invalid Server Response"
        case .badRequest:
            return "Bad Request"
        case .incorrectURL:
            return "Incorrect URL"
        case .requestEncodingError(let error):
            return error
        }
    }
}

enum ParsingError: Error, LocalizedError {
    
     case parserError(error: String)
    var errorDescription: String {
        switch self {
        case .parserError(let reason):
            return reason
        }
    }
}
