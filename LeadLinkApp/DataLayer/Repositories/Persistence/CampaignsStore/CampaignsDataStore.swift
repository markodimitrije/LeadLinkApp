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
    func save(campaigns: [CampaignProtocol]) -> Promise<[CampaignProtocol]>
    func delete(campaigns: [CampaignProtocol]) -> Promise<[CampaignProtocol]>
}

protocol CampaignsDataStore: CampaignsDataStoreBase {
    func deleteCampaignRelatedData()
    func deleteAllCampaignRelatedDataExceptJson()
}

