//
//  TokenAndCredentials.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 20/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct SignInToken: Codable {
    var token: String
}

public struct LoginCredentials: Codable {
    var email: String
    var password: String
}
