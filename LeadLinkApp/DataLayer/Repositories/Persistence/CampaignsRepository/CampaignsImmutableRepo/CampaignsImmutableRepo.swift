//
//  CampaignsImmutableRepo.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 04/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import PromiseKit
import RxSwift
import RealmSwift

class CampaignsImmutableRepository: ICampaignsImmutableRepository {
    
    func readCampaign(id: Int) -> Promise<CampaignProtocol> {
        
        return Promise() { seal in
            
            let realm = RealmFactory.make()
            
            guard let result = realm.object(ofType: RealmCampaign.self, forPrimaryKey: id) else {
                //fatalError("asking for not existing code in database!")
                seal.reject(CampaignError.unknown)
                return
            }
            
            seal.fulfill(Campaign.init(realmCampaign: result))
            
        }
        
    }
    
    func readAllCampaigns() -> Promise<[CampaignProtocol]> {
        
        return Promise() { seal in
            
            let realm = RealmFactory.make()
            
            let results = realm.objects(RealmCampaign.self).sorted(by: {$0.id < $1.id})
            
            let campaigns = results.map {Campaign.init(realmCampaign: $0)}
            
            seal.fulfill(campaigns)
            
        }
        
    }
    
    func fetchCampaign(_ campaignId: Int) -> Observable<CampaignProtocol> {
        let realm = RealmFactory.make()
        guard let realmCampaign = realm.object(ofType: RealmCampaign.self, forPrimaryKey: campaignId) else {
            fatalError("someone asked for selected campaign, before it was saved ?!?")
        }
        return Observable.from(object: realmCampaign).map(Campaign.init)
    }
    
}

