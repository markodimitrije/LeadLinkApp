//
//  SignInResponse.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 02/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct SignInResponsePayload: Codable {
    var data: SignInToken
}

struct SignInToken: Codable {
    var token: String
}


public struct LoginCredentials: Codable {
    var email: String
    var password: String
}
