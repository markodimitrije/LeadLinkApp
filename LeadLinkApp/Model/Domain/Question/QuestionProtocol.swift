//
//  QuestionProtocol.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 30/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
protocol QuestionProtocol {
    func getId() -> Int
    func getCampaignId() -> Int
    func getType() -> QuestionType
    func getGroup() -> String
    func getTitle() -> String
    func getDesc() -> String
    func getOrder() -> Int
    func getElementId() -> Int?
    func getSettings() -> QuestionSettings
    func getOptions() -> [String]
}
