//
//  Repository.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 30/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import PromiseKit

public protocol UserSessionRepositoryProtocol {
    
    func readUserSession() -> Promise<UserSession>
    func signIn(email: String, password: String) -> Promise<UserSession>
    func signOut(userSession: UserSession) -> Promise<UserSession>
}

public class UserSessionRepository: UserSessionRepositoryProtocol {
    
    // MARK: - Properties
    let dataStore: UserSessionDataStore
    let remoteAPI: AuthRemoteAPIProtocol
    
    // MARK: - Methods
    public init(dataStore: UserSessionDataStore, remoteAPI: AuthRemoteAPIProtocol) {
        self.dataStore = dataStore
        self.remoteAPI = remoteAPI
    }
    
    public func readUserSession() -> Promise<UserSession> {
        return dataStore.readUserSession()
    }
    
    public func signIn(email: String, password: String) -> Promise<UserSession> {
        
        let credentials = LoginCredentials.init(email: email, password: password)
        return remoteAPI.logIn(credentials: credentials)
            .then(dataStore.save(userSession:))
            .get { [weak self] userSession in
                let bearerToken = "Bearer " + userSession.remoteSession.token
                self?.updateDataModelWith(authToken: bearerToken)
            }
    }
    
    public func signOut(userSession: UserSession) -> Promise<UserSession> {
        
        return remoteAPI.logOut(userSession: userSession)
            .then(dataStore.delete(userSession:))
            .get { userSession in
                UserDefaults.standard.set(nil, forKey: UserDefaults.keyConferenceAuth)
        }
    }
    
    private func updateDataModelWith(authToken: String?) {
        
        if let authToken = authToken {
            UserDefaults.standard.set(authToken, forKey: UserDefaults.keyConferenceAuth)
            confApiKeyState = ConferenceApiKeyState(authToken: authToken)
        } else {
            UserDefaults.standard.set(nil, forKey: UserDefaults.keyConferenceAuth)
            //confApiKeyState = nil hard-coded
        }
        
    }
}



