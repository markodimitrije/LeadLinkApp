//
//  MyAnswerProtocol.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 30/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol MyAnswerProtocol {
    var campaignId: Int {get set}
    var questionId: Int {get set}
    var code: String {get set}
    var id: String {get set}
    var content: [String] {get set}
    var optionIds: [Int]? {get set}
    var questionType: String {get set}
}
