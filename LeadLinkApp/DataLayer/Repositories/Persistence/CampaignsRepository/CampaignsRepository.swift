//
//  File.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 04/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import PromiseKit
import RxSwift
import RealmSwift

protocol CampaignsRepositoryProtocol {
    func fetchCampaign(_ campaignId: Int) -> Observable<CampaignProtocol>
}

extension CampaignsRepository: CampaignsRepositoryProtocol {
    
    func fetchCampaign(_ campaignId: Int) -> Observable<CampaignProtocol> {
        let realm = try! Realm()
        guard let realmCampaign = realm.object(ofType: RealmCampaign.self, forPrimaryKey: campaignId) else {
            fatalError("someone asked for selected campaign, before it was saved ?!?")
        }
        return Observable.from(object: realmCampaign).map(Campaign.init)
    }
}

struct CampaignsRepository {
    
    // MARK: - Properties
    let dataStore: ICampaignsRepository
    let userSessionRepository: UserSessionRepository
    let remoteAPI: CampaignsRemoteAPI
    
    // MARK: - Methods
    init(userSessionRepository: UserSessionRepository, dataStore: ICampaignsRepository, remoteAPI: CampaignsRemoteAPI) {
        self.userSessionRepository = userSessionRepository
        self.dataStore = dataStore
        self.remoteAPI = remoteAPI
    }

}
