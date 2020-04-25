//
//  CampaignsMutableRepo.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 25/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import PromiseKit
import RxSwift
import RealmSwift

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
