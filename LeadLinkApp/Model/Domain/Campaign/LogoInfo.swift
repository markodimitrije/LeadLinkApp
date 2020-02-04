//
//  LogoInfo.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 10/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

public struct LogoInfo {
    var id: Int
    var url: String?
    var imgData: Data?
    init(campaign: CampaignProtocol) {
        self.id = campaign.id
        self.url = campaign.logo
        self.imgData = nil
    }
    init(id: Int, url: String?, imgData: Data?) {
        self.id = id
        self.url = url
        self.imgData = imgData
    }
}
