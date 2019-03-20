//
//  CodesErrors.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 20/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import PromiseKit

enum CodeError: Error {
    case unknown
    case cantSave
    case cantDelete
    case cantRead
    
    func translateToErrorMessage() -> ErrorMessage {
        switch self {
        case .cantSave:
            return ErrorMessage.init(title: "Error", message: "Could not save campaigns.\n Maybe there is not enough storage?")
        case .cantDelete:
            return ErrorMessage.init(title: "Error", message: "Could not delete campaigns.\n Check storage permissions.")
        case .unknown:
            return ErrorMessage.init(title: "Error", message: "Could not execute campaigns task.\n Unknown error occured.")
        case .cantRead:
            return ErrorMessage.init(title: "'Error'", message: "Could not read code.\n The code was not previously saved.")
        }
        
    }
    
}
