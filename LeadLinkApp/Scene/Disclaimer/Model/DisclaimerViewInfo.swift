//
//  DisclaimerViewInfo.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 22/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct DisclaimerViewInfo {
    var disclaimer: Disclaimer
    var title: String = ""
    var disagreeTitle: String = ""
    var agreeTitle: String = ""
    init(disclaimer: Disclaimer) {
        self.disclaimer = disclaimer
        self.title = Constants.Disclaimer.title
        self.disagreeTitle = Constants.Disclaimer.disagree
        self.agreeTitle = Constants.Disclaimer.agree
    }
}
