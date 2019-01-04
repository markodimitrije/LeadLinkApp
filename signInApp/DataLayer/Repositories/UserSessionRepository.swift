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
    
    public func signOut(userSession: UserSession) -> Promise<UserSession> {
        
        return remoteAPI.logOut(userSession: userSession)
            .then(dataStore.delete(userSession:))
    }
    
    
    
}


public protocol UserCampaignsRepository {
    
    func readCampaigns(userSession: UserSession) -> Promise<[Campaign]>
    //func readQuestions(userSession: UserSession) -> Promise<[Question]> // imas u main proj..

}

public class CampaignsRepository: UserCampaignsRepository {
    
    // MARK: - Properties
    let dataStore: UserCampaignsDataStore
    let userSession: UserSession
    let remoteAPI: RemoteAPI
    
    // MARK: - Methods
    public init(userSession: UserSession, dataStore: UserCampaignsDataStore, remoteAPI: RemoteAPI) {
        self.userSession = userSession
        self.dataStore = dataStore
        self.remoteAPI = remoteAPI
    }
    
    public func readCampaigns(userSession: UserSession) -> Promise<[Campaign]> {
        
        return remoteAPI.getCampaigns(userSession: userSession)
            .then(dataStore.save(campaigns:))
    }
    
}
