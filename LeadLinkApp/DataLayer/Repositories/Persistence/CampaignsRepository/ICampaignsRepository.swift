//
//  ICampaignsRepository.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 25/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import PromiseKit
import RxSwift

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
