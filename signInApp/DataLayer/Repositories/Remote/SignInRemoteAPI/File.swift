//
//  File.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 30/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import PromiseKit

public protocol NewRideRemoteAPI {
    
    func getCampaigns(auth: AuthToken) -> Promise<[Campaign]>
    
}

enum RemoteAPIError: Error {
    
    case unknown
    case createURL
    case httpError
}
