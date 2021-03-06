//
//  ReportsDataStoreProtocol.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RxCocoa

protocol ReportsDataStoreProtocol {
    /// Read
    var campaignId: Int {get set}
    var oReports: BehaviorRelay<[AnswersReportProtocol]> {get set}
}
