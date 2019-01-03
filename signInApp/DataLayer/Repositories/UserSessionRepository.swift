//
//  Repository.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 30/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import PromiseKit

public protocol UserSessionRepository {
    
    func readUserSession() -> Promise<UserSession?>
    func signIn(email: String, password: String) -> Promise<UserSession>
    func signOut(userSession: UserSession) -> Promise<UserSession>
}

public class LeadLinkUserSessionRepository: UserSessionRepository {
    
    // MARK: - Properties
    let dataStore: UserSessionDataStore
    let remoteAPI: AuthRemoteAPI
    
    // MARK: - Methods
    public init(dataStore: UserSessionDataStore, remoteAPI: AuthRemoteAPI) {
        self.dataStore = dataStore
        self.remoteAPI = remoteAPI
    }
    
    public func readUserSession() -> Promise<UserSession?> {
        return dataStore.readUserSession()
    }
    
    public func signIn(email: String, password: String) -> Promise<UserSession> {
        let credentials = LoginCredentials.init(email: email, password: password)
        return remoteAPI.logIn(credentials: credentials)
            .then(dataStore.save(userSession:))
    }
    
//    public func signOut(userSession: UserSession) -> Promise<UserSession> {
//        return dataStore.delete(userSession: userSession)
//    }
    public func signOut(userSession: UserSession) -> Promise<UserSession> {
        
        return remoteAPI.logOut(userSession: userSession)
            .then(dataStore.delete(userSession:))
            //.catch(<#T##body: (Error) -> Void##(Error) -> Void#>)
    }
}
