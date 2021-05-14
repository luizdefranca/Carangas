//
//  RestError.swift
//  Carangas
//
//  Created by Luiz on 5/13/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Foundation

enum RestError: Error, CustomStringConvertible {
    case url
    case taskError(error: Error)
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidJSON

    public var description: String {
        switch self {
            case .url:
                return "Error Found : URL error."
            case .taskError(error: let error):
                return "Error Found : The Data Task object failed. Error: \(error)"
            case .noResponse:
                return "Error Found : Request without response"
            case .noData:
                return "Error Found : The data from API is Nil."
            case .responseStatusCode(code: let code):
                return "Error Found : Invalid status code - \(code)"
            case .invalidJSON:
                return "Error Found : Unable to parse the JSON response"
        }
    }
}
