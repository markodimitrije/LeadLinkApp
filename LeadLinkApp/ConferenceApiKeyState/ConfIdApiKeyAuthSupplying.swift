//
//  File.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 06/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol ConfIdApiKeyAuthSupplying {
    var conferenceId: Int? {get set}
    var apiKey: String? {get set}
    var authentication: String? {get set}
}
