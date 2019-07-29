//
//  IphoneQuestionsAnswersTableViewHeaderFooterCalculator.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 25/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

protocol QuestionsAnswersTableViewHeaderFooterCalculating {
    func getHeaderHeight() -> CGFloat
    func getFooterHeight() -> CGFloat
}

class IphoneQuestionsAnswersTableViewHeaderFooterCalculator: QuestionsAnswersTableViewHeaderFooterCalculating {
    
    func getHeaderHeight() -> CGFloat {
        return CGFloat.init(44)
    }
    
    func getFooterHeight() -> CGFloat {
        return CGFloat.init(30)
    }
}

class IpadQuestionsAnswersTableViewHeaderFooterCalculator: QuestionsAnswersTableViewHeaderFooterCalculating {
    
    func getHeaderHeight() -> CGFloat {
        return CGFloat.init(60)
    }
    
    func getFooterHeight() -> CGFloat {
        return CGFloat.init(30)
    }
}
