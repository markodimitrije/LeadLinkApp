//
//  AuthRemoteAPIProtocol.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 30/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import PromiseKit

public protocol AuthRemoteAPIProtocol: LoginRemoteAPIProtocol, LogoutRemoteAPIProtocol {}

public protocol LoginRemoteAPIProtocol {
    func logIn(credentials: LoginCredentials) -> Promise<UserSession>
}

public protocol LogoutRemoteAPIProtocol {
    func logOut(userSession: UserSession) -> Promise<UserSession>
}
