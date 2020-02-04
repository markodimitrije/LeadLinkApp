//
//  CampaignsDataStore.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 04/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import PromiseKit

protocol CampaignsDataStoreBase {
    func readAllCampaigns() -> Promise<[CampaignProtocol]>
    func readCampaign(id: Int) -> Promise<CampaignProtocol>
    func save(campaigns: [Campaign]) -> Promise<[CampaignProtocol]>
    func delete(campaigns: [Campaign]) -> Promise<[CampaignProtocol]>
}

protocol CampaignsDataStore: CampaignsDataStoreBase {
    func readAllCampaignLogoInfos() -> Promise<[LogoInfo]>
    func getCampaignsJsonString(requestName name: String) -> Promise<String>
    func saveCampaignsJsonString(requestName name: String, json: String) -> Promise<Bool>
    func deleteCampaignRelatedData()
}

