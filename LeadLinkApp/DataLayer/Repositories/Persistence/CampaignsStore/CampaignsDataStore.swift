//
//  ICampaignsRepository.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 04/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import PromiseKit
import RxSwift
import RealmSwift

protocol ICampaignsRepository: ICampaignsImmutableRepository, ICampaignsMutableRepository {}

protocol ICampaignsImmutableRepository {
    func readAllCampaigns() -> Promise<[CampaignProtocol]>
    func readCampaign(id: Int) -> Promise<CampaignProtocol>
    func fetchCampaign(_ campaignId: Int) -> Observable<CampaignProtocol>
}

protocol ICampaignsMutableRepository {
    func save(campaigns: [CampaignProtocol]) -> Promise<[CampaignProtocol]>
    func delete(campaigns: [CampaignProtocol]) -> Promise<[CampaignProtocol]>
    func deleteCampaignRelatedData()
}

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



class CampaignsMutableRepository: ICampaignsMutableRepository {
    
    func save(campaigns: [CampaignProtocol]) -> Promise<[CampaignProtocol]> {
            
            return Promise() { seal in
                
                let realm = RealmFactory.make()
                
                let objects = campaigns.compactMap { campaign -> RealmCampaign? in
                    let rc = RealmCampaign()
                    rc.update(with: campaign)
                    return rc
                }
                
                do {
                    try realm.write {
                        realm.add(objects, update: .modified)
                    }
    //                print("SAVED CAMPAIGNS!")
                    seal.fulfill(campaigns)
                } catch {
                    seal.reject(CampaignError.cantSave)
                }
                
            }
        }
        
        func delete(campaigns: [CampaignProtocol]) -> Promise<[CampaignProtocol]> {
            
            let realm = RealmFactory.make()
            
            let ids = campaigns.map {$0.id}
            
            return Promise() { seal in
                
                let objects = realm.objects(RealmCampaign.self).filter { campaign -> Bool in
                    return ids.contains(campaign.id)
                }
                
                do {
                    try realm.write { // ovako
                        realm.delete(objects)
                    }
                    seal.fulfill(campaigns)
                } catch {
                    seal.reject(CampaignError.cantDelete)
                }
                
            }
        }
        
        public func deleteCampaignRelatedData() { // TODO marko: rename no json..
            
            _ = campaignObjectTypes.map { type -> Void in
                _ = self.deleteAllObjects(ofTypes: [type])
            }
        }
        
        // MARK: delete
        
        private func deleteAllObjects<T: Object>(ofTypes types: [T.Type]) -> Observable<Bool> {
            let realm = RealmFactory.make()
            do {
                try realm.write {
                    for type in types {
                        let objects = realm.objects(type)
                        realm.delete(objects)
                    }
                }
            } catch {
                return Observable<Bool>.just(false) // treba da imas err za Realm...
            }
            return Observable<Bool>.just(true) // all good
        }
        
        private var campaignObjectTypes: [Object.Type] = [RealmCampaign.self,
                                                          RealmSettings.self,
                                                          RealmOrganization.self,
                                                          RealmApplication.self,
                                                          RealmQuestion.self,
                                                          RealmQuestionSettings.self,
                                                          RealmDisclaimer.self,
                                                          RealmOptIn.self]
}
