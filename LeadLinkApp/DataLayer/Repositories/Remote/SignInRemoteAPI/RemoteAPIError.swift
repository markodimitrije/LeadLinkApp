//
//  RemoteAPIError.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 30/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import PromiseKit

enum RemoteAPIError: Error {
    case unknown
    case createURL
    case httpError
    case unauthorized([String])
    case unprocessableEntity(String, [String])
    
    func translateToErrorMessage() -> ErrorMessage {
        
        switch self {
        case .createURL, .httpError, .unknown:
            return ErrorMessage.init(title: "Sign In Failed", message: "Could not sign in.\nPlease try again.")
        case .unauthorized(let msg):
            return ErrorMessage.init(title: "Sign In Failed", message: msg.first ?? "Could not sign in.\nPlease try again.")
        case .unprocessableEntity(let title, let errorMsgs):
            let message = errorMsgs.reduce("") { (sum, next) -> String in
                sum + "\n" + next
            }
            return ErrorMessage.init(title: title, message: message)
        
        }
        
    }
    
}
