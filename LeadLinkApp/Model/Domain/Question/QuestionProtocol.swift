//
//  QuestionProtocol.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 30/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
protocol QuestionProtocol {
    var qId: Int {get}
    var qCampaignId: Int {get}
    var qType: QuestionType {get}
    var qTitle: String {get}
    var qGroup: String {get}
    var qDesc: String {get}
    var qOrder: Int {get}
    var qSettings: QuestionSettingsProtocol {get}
    var qOptions: [String] {get}
    var qMultipleSelection: Bool {get}
}
