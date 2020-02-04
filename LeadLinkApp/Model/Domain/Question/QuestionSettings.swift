//
//  QuestionSettings.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 30/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol QuestionSettingsProtocol {
    var options: [String]? { get set }
}

public struct QuestionSettings: Codable, QuestionSettingsProtocol {
    var options: [String]?
    
    init(realmSetting: RealmQuestionSettings) {
        //self.options = realmSetting.options.sorted()
        self.options = realmSetting.options.toArray()
    }
    
    init(questionSettingsResponse: QuestionSettingsResponseProtocol) {
        self.options = questionSettingsResponse.options
    }
}
