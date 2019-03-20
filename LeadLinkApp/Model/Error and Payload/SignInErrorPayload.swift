//
//  SignInErrorPayload.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 02/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct UnauthorizedPayload: Codable {
    var message: String
}


struct UnprocessableEntityPayload: Codable {
    var message: String
    var errors: EmailPassError
}

struct EmailPassError: Codable {
    var email: [String]?
    var password: [String]?
}
