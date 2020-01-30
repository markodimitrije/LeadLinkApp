//
//  QuestionSettingsResponse.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 30/01/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct QuestionSettingsResponse: QuestionSettingsResponseProtocol {
    var options: [String]
    init?(json: [String: Any]?) {
        guard let json = json else {
            return nil
        }
        self.options = json["options"] as? [String] ?? [ ]
    }
}
