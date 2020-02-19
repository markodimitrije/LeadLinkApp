//
//  QA_ValidatorFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 19/02/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct QA_ValidatorFactory {
    func make(campaign: CampaignProtocol) -> QA_ValidationProtocol {
        let termsAndEmailQuestions = campaign.questions.filter {$0.qType == .termsSwitchBtn || $0.qOptions.first(where: {$0 == "email"}) != nil }
        if termsAndEmailQuestions.count == 0 || termsAndEmailQuestions.count == 1 {
            return NoEmailAndTerms_QA_Validation()
        } else {
            return QA_Validation(campaign: campaign)
        }
    }
}
