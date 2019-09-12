//
//  File.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 30/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import PromiseKit

public protocol AuthRemoteAPIProtocol {
    func logIn(credentials: LoginCredentials) -> Promise<UserSession>
    func logOut(userSession: UserSession) -> Promise<UserSession>
}
