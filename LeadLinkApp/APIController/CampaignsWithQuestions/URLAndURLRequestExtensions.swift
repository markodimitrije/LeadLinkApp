//
//  CampaignsWithQuestions.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 27/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

extension URL {
    static var campaignsWithQuestions = URL.init(string: "https://service.e-materials.com/api/leadlink/campaigns?include=questions,organization,application")!
    static var campaignsWithQuestionsMOCK = URL.init(string: "https://ee0a4cff-6754-453d-a736-412c0085a44b.mock.pstmn.io/api/leadlink/campaigns/questions,application")!
}

extension URLRequest {
    static var campaignsWithQuestions = URLRequest.init(url: URL.campaignsWithQuestions)
    static var campaignsWithQuestionsMock = URLRequest.init(url: URL.campaignsWithQuestionsMOCK)
}
