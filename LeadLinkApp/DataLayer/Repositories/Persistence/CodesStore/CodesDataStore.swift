//
//  CodesDataStore.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 20/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import PromiseKit
import RxCocoa

public protocol CodesDataStore {
    /// Read
    func readCodes(campaignId: Int) -> Promise<[Code]>
    /// Save
    func save(code: Code) -> Promise<Code>
    // Read sync
    func getCodes(campaignId: Int) -> [Code]
}

