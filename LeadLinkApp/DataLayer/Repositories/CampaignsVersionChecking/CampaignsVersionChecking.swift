//
//  CampaignsVersionChecking.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import PromiseKit

public protocol CampaignsVersionChecking {
    func needsUpdate(newJson json: String) -> Promise<Bool>
}
