//
//  AuthRemoteAPI.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 30/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import PromiseKit

public struct AuthRemoteAPI: AuthRemoteAPIProtocol {
    
    let loginRemoteAPI: LoginRemoteAPIProtocol
    let logoutRemoteAPI: LogoutRemoteAPIProtocol
    
    static let shared = AuthRemoteAPI(loginRemoteAPI: LoginAuthRemoteAPI.shared,
                                      logoutRemoteAPI: LogoutAuthRemoteAPI.shared)
    
    // MARK:- Properties
    
    private var authorization: String {
        return confApiKeyState!.authentication ?? "error"
    }
    
    // MARK: - Methods
    
    private init(loginRemoteAPI: LoginRemoteAPIProtocol, logoutRemoteAPI: LogoutRemoteAPIProtocol) {
        self.loginRemoteAPI = loginRemoteAPI
        self.logoutRemoteAPI = logoutRemoteAPI
    }
    
    public func logIn(credentials: LoginCredentials) -> Promise<UserSession> {
        return loginRemoteAPI.logIn(credentials: credentials)
    }
    
    public func logOut(userSession: UserSession) -> Promise<UserSession> {
        return logoutRemoteAPI.logOut(userSession: userSession)
    }
    
}
