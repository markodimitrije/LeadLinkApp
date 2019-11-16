//
//  RemoteApi.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 04/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import PromiseKit

public protocol CampaignsRemoteAPI {
    func getCampaignsWithQuestions(userSession: UserSession) -> Promise<CampaignResults>
}

public protocol DownloadImageAPI {
    func getImage(url: String) -> Promise<Data?>
}

struct WebRequestName {
    static let campaignsWithQuestions = "campaigns?include=questions,organization"
}
