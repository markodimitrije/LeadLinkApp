//
//  RemoteApi.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 04/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import PromiseKit

public protocol CampaignsRemoteAPI {
    //func getCampaigns(userSession: UserSession) -> Promise<[Campaign]>
    //func getQuestions(campaignId id: Int) -> Promise<[Question]>
    func getCampaignsAndQuestions(userSession: UserSession) -> Promise<[(Campaign, [Question])]>
}
