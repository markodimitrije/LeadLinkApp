//
//  File.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 04/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import PromiseKit

public protocol UserCampaignsRepository {
    
    func readCampaigns(userSession: UserSession) -> Promise<[Campaign]>
    //func readQuestions(userSession: UserSession) -> Promise<[Question]> // imas u main proj..
    
}

public class CampaignsRepository: UserCampaignsRepository {
    
    // MARK: - Properties
    let dataStore: CampaignsDataStore
    let userSession: UserSession??
    let remoteAPI: CampaignsRemoteAPI
    
    // MARK: - Methods
    public init(userSession: UserSession??, dataStore: CampaignsDataStore, remoteAPI: CampaignsRemoteAPI) {
        self.userSession = userSession
        self.dataStore = dataStore
        self.remoteAPI = remoteAPI
    }
    
    public func readCampaigns(userSession: UserSession) -> Promise<[Campaign]> { // readAllCampaigns()
        
        return remoteAPI.getCampaigns(userSession: userSession)
            .then(dataStore.save(campaigns:))
    }
    
}
