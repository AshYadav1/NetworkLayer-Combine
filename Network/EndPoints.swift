//
//  EndPoints.swift
//
//  Created by Ashish on 08/05/2023.
//

import Foundation

protocol APiEndPoints {
    var value: String { get }
}

enum OnBoardingEndPoint: String, APiEndPoints {
    case login
    case signup
    
    var value: String {
        return self.rawValue
    }
}
