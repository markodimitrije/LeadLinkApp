//
//  CampaignsErrors.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 04/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import PromiseKit

enum CampaignError: Error {
    case unknown
    case cantSave
    case cantDelete
    case dontNeedUpdate// nije pravi Err
    case noCampaignsFound
    
    func translateToErrorMessage() -> ErrorMessage {
        switch self {
        case .cantSave:
            return ErrorMessage.init(title: "Error", message: "Could not save campaigns.\n Maybe there is not enough storage?")
        case .cantDelete:
            return ErrorMessage.init(title: "Error", message: "Could not delete campaigns.\n Check storage permissions.")
        case .unknown:
            return ErrorMessage.init(title: "Error", message: "Could not execute campaigns task.\n Unknown error occured.")
        case .dontNeedUpdate:
            return ErrorMessage.init(title: "'Error'", message: "Not really error, used to break chain if update campaigns not needed.")
        case .noCampaignsFound:
            return ErrorMessage.init(title: "'Error'", message: "No valid campaigns found. Please go to Configurator to set up your campaigns.")
            
        }
        
    }
    
}
