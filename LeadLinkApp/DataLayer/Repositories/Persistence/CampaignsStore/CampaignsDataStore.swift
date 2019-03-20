//
//  CampaignsDataStore.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 04/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import PromiseKit

public protocol CampaignsDataStoreBase {
    
    func readAllCampaigns() -> Promise<[Campaign]>
    func readCampaign(id: Int) -> Promise<Campaign>
    func save(campaigns: [Campaign]) -> Promise<[Campaign]>
    func delete(campaigns: [Campaign]) -> Promise<[Campaign]>
    
}

public protocol CampaignsDataStore: CampaignsDataStoreBase {
    func readAllCampaignLogoInfos() -> Promise<[LogoInfo]>
    func getCampaignsJsonString(requestName name: String) -> Promise<String>
    func saveCampaignsJsonString(requestName name: String, json: String) -> Promise<Bool>
}
