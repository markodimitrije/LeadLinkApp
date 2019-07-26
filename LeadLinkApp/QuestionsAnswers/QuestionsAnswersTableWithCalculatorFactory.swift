//
//  QuestionsAnswersTableWithCalculatorFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 26/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class QuestionsAnswersTableWidthCalculatorFactory {
    func makeWidthCalculator() -> QuestionsAnswersTableWidthCalculating {
        
        if getDeviceType() == .iPad {
            return IpadQuestionsAnswersTableWidthCalculator()
        }
        return IphoneQuestionsAnswersTableWidthCalculator()
    }
}
