//
//  RealmCampaignsDataStore.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 04/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import PromiseKit
import Realm
import RealmSwift
import RxSwift
import RxRealm

public class RealmCampaignsDataStore: CampaignsDataStore {
    
    // MARK: - Properties
    var realm = try! Realm.init()
    
    // MARK: - manage campaigns
    
    public func readCampaign(id: Int) -> Promise<Campaign> {
        
        return Promise() { seal in
            
            guard let _ = try? Realm.init() else {
                seal.reject(CampaignError.unknown)
                return
            }
            
            guard let result = realm.object(ofType: RealmCampaign.self, forPrimaryKey: id) else {
                //fatalError("asking for not existing code in database!")
                seal.reject(CampaignError.unknown)
                return
            }
            
            seal.fulfill(Campaign.init(realmCampaign: result))
            
        }
        
    }
    
    public func readAllCampaigns() -> Promise<[Campaign]> {
        
        return Promise() { seal in
            
            guard let _ = try? Realm.init() else {
                seal.reject(CampaignError.unknown)
                return
            }
            
            let results = realm.objects(RealmCampaign.self).sorted(by: {$0.id < $1.id})
            
            let campaigns = results.map {Campaign.init(realmCampaign: $0)}
            
            seal.fulfill(campaigns)
            
        }
        
    }
    
    public func save(campaigns: [Campaign]) -> Promise<[Campaign]> {
        
        return Promise() { seal in
            
            let objects = campaigns.compactMap { campaign -> RealmCampaign? in
                let rc = RealmCampaign()
                rc.update(with: campaign)
                return rc
            }
            
            do {
                try realm.write { // ovako
                    realm.add(objects, update: true)
                }
                //                print("SAVED CAMPAIGNS!")
                seal.fulfill(campaigns)
            } catch {
                seal.reject(CampaignError.cantSave)
            }
            
        }
    }
    
    public func delete(campaigns: [Campaign]) -> Promise<[Campaign]> {
        
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
    
    // MARK: - manage logo(s)
    
    public func readAllCampaignLogoInfos() -> Promise<[LogoInfo]> {
        
        return readAllCampaigns().map { camps -> [LogoInfo] in
            return camps.compactMap { LogoInfo.init(campaign: $0) }
        }
        
    }
    
    // MARK: - manage json
    
    public func getCampaignsJsonString(requestName name: String) -> Promise<String> {
        
        return Promise() { seal in
            
            guard let realm = try? Realm.init() else {
                seal.reject(CampaignError.unknown)
                return
            }
            
            guard let realmJson = realm.objects(RealmJson.self).first(where: {$0.name == name} ) else {
                seal.fulfill("") // ako nemas nista
                return
            }
            
            seal.fulfill(realmJson.value)
            
        }
        
    }
    
    public func saveCampaignsJsonString(requestName name: String, json: String) -> Promise<Bool> {
        
        return Promise() { seal in
            
            let object = RealmJson()
            object.update(name: name, value: json)
            
            do {
                try realm.write {
                    realm.add(object, update: true)
                }
                print("SAVED JSON za kampanje !")
                seal.fulfill(true)
            } catch {
                seal.reject(CampaignError.cantSave)
            }
            
        }
        
    }
    
    public func deleteCampaignsJsonString() -> Promise<Bool> {
        
        return Promise() { seal in
            
            guard let object = realm.objects(RealmJson.self).first else {
                seal.fulfill(true) // realno je error...
                return
            }
            
            do {
                try realm.write {
                    realm.delete(object)
                }
                print("DELETE JSON za versioning za kampanje.... !")
                seal.fulfill(true)
            } catch {
                seal.reject(CampaignError.cantSave)
            }
            
        }
        
    }
    
}
