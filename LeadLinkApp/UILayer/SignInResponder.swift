//
//  SignInResponder.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 03/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

public protocol SignedInResponder {
    func signedIn(to userSession: UserSession)
}

public protocol NotSignedInResponder {
    
    func notSignedIn()
}
