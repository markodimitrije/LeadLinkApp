//
//  CampaignResults.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

public struct CampaignResults {
    var campaignsWithQuestions = [(CampaignProtocol, [QuestionProtocol])]()
    var jsonString: String = ""
}
