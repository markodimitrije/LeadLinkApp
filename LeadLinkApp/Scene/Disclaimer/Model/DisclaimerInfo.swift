//
//  DisclaimerInfo.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 22/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct DisclaimerInfo {
    var title: String = ""
    var text: String = ""
    var disagreeTitle: String = ""
    var agreeTitle: String = ""
    init(campaign: Campaign) {
        self.title = Constants.Disclaimer.title
        self.text = Constants.Disclaimer.text
        self.disagreeTitle = Constants.Disclaimer.disagree
        self.agreeTitle = Constants.Disclaimer.agree
    }
}
