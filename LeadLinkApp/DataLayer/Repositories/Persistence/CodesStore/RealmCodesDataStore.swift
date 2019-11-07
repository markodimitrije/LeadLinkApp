//
//  RealmCodesDataStore.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 20/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import PromiseKit
import Realm
import RealmSwift

public class RealmCodesDataStore: CodesDataStore {
    
    var realm = try! Realm.init()
    var campaignsDataStore: CampaignsDataStore
    
    init(campaignsDataStore: CampaignsDataStore, realm: Realm? = nil) {
        self.campaignsDataStore = campaignsDataStore
        if let realm = realm {
            self.realm = realm
        }
    }
    
    public func readCodes(campaignId id: Int) -> Promise<[Code]> {
        
        return Promise() { seal in
            
            let codes = getCodes(campaignId: id)
            
            seal.fulfill(codes)
            
        }
        
    }
    
    public func save(code: Code) -> Promise<Code> {
        
        return Promise() { seal in
            
            let rCode = RealmCode.init()
            rCode.update(with: code)

            do {
                try realm.write {
                    print("code = \(code.value) successfully saved in realm")
                    realm.add(rCode, update: .modified)
                }
            } catch {
                print("RealmCodesDataStore.save.... o-o... catch")
                seal.reject(CodeError.cantSave)
            }
          
            seal.fulfill(code)
            
        }
        
    }
    
    // sync
    
    public func getCodes(campaignId id: Int) -> [Code] {
        
        let rCodes = realm.objects(RealmCode.self).filter("campaign_id == %i", id).toArray()
        
        return rCodes.map(Code.init)
        
    }
    
}
