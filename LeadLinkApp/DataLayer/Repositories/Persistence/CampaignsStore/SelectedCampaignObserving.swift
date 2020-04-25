//
//  SelectedCampaignObserving.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 16/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RealmSwift
import RxSwift

protocol SelectedCampaignObserving {
    func selectedCampaign() -> Observable<CampaignProtocol?> // treba da zivi na userSession dok je login
}

struct RealmSelectedCampaign: SelectedCampaignObserving {
    
    var campaignsRepo: ICampaignsImmutableRepository
    
    init(campaignsRepo: ICampaignsImmutableRepository) {
        self.campaignsRepo = campaignsRepo
    }
    
    func selectedCampaign() -> Observable<CampaignProtocol?> {
        guard let id = selectedCampaignId else {
            fatalError() // bolje vrati error...
        }
        
        let realm = try! Realm()
        let realmCampaigns = realm.objects(RealmCampaign.self)
        
        let obs: Observable<RealmCampaign?> = Observable.collection(from: realmCampaigns)
            .map {
                realmCampaigns in
                let realmCampaign = realmCampaigns.toArray().first(where: {$0.id == id})
                return realmCampaign
        }
        
        return obs.map { realmCampaign -> Campaign? in
            if let realmCampaign = realmCampaign {
                return Campaign(realmCampaign: realmCampaign)
            } else {
                return nil
            }
        }
    }
}
