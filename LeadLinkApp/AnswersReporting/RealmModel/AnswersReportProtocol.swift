//
//  AnswersReportProtocol.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 30/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol AnswersReportProtocol {
    func getPayload() -> [[String: String]]
    func updated(withSuccess success: Bool) -> AnswersReportProtocol
    var campaignId: String { get set }
    var code: String { get set }
    var success: Bool { get set }
    var date: Date { get set }
}
