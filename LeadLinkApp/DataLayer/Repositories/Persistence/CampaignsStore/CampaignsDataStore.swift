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

protocol ICampaignsRepository {
    func readAllCampaigns() -> Promise<[CampaignProtocol]>
    func readCampaign(id: Int) -> Promise<CampaignProtocol>
    func save(campaigns: [CampaignProtocol]) -> Promise<[CampaignProtocol]>
    func delete(campaigns: [CampaignProtocol]) -> Promise<[CampaignProtocol]>
    func deleteCampaignRelatedData()
}

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

protocol ICampaignsRepositoryNew: ICampaignsRepository, ICampaignsMutableRepository {}
