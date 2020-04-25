//
//  CampaignsErrors.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 04/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

enum CampaignError: Error {
    case unknown
    case cantSave
    case cantDelete
    case userNotLoggedInError
    case noCampaignsFound
    case mandatoryKeyIsMissing
    
    func translateToErrorMessage() -> ErrorMessage {
        switch self {
        case .cantSave:
            return ErrorMessage.init(title: "Error", message: "Could not save campaigns.\n Maybe there is not enough storage?")
        case .cantDelete:
            return ErrorMessage.init(title: "Error", message: "Could not delete campaigns.\n Check storage permissions.")
        case .userNotLoggedInError:
            return ErrorMessage.init(title: "Error", message: "User not logged in.\n Please log in again.")
        case .unknown:
            return ErrorMessage.init(title: "Error", message: "Could not execute campaigns task.\n Unknown error occured.")
        case .noCampaignsFound:
            return ErrorMessage.init(title: "'Error'", message: "No valid campaigns found. Please go to Configurator to set up your campaigns.")
        case .mandatoryKeyIsMissing:
            return ErrorMessage.init(title: "Error", message: "Mandatory key is missing. Please contact Navus Team.")
        }
        
    }
    
}
