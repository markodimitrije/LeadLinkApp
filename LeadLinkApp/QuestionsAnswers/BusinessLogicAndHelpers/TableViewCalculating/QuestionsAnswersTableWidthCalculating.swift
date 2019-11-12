//
//  QuestionsAnswersTableWidthCalculating.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 26/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

protocol QuestionsAnswersTableWidthCalculating {
    func getWidth() -> CGFloat
}

class IphoneQuestionsAnswersTableWidthCalculator: QuestionsAnswersTableWidthCalculating {
    
    func getWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
}

class IpadQuestionsAnswersTableWidthCalculator: QuestionsAnswersTableWidthCalculating {
    
    func getWidth() -> CGFloat {
        return UIScreen.main.bounds.width * 0.6
    }
    
}
