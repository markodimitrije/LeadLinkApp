//
//  CampaignsDataStore.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 04/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import PromiseKit

public protocol CampaignsDataStoreOld {
    
    func readAllCampaigns() -> Promise<[Campaign]>
    func save(campaigns: [Campaign]) -> Promise<[Campaign]>
    func delete(campaigns: [Campaign]) -> Promise<[Campaign]>
    
}

public protocol CampaignsDataStore: CampaignsDataStoreOld {
    func readAllCampaignLogoUrls() -> Promise<[LogoInfo]>
}
