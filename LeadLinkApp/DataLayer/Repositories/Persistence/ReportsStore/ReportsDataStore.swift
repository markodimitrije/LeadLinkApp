//
//  ReportsDataStore.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RxCocoa

protocol ReportsDataStore {
    /// Read
    var campaignId: Int {get set}
    var oReports: BehaviorRelay<[RealmWebReportedAnswers]> {get set}
}
