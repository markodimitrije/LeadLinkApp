//
//  QuestionsAnswersTableRowHeightCalculator.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 19/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

protocol QuestionsAnswersTableRowHeightCalculating {
    func getOneRowHeight(componentType type: QuestionType) -> CGFloat
}

class IphoneQuestionsAnswersTableRowHeightCalculator: QuestionsAnswersTableRowHeightCalculating {
    
    func getOneRowHeight(componentType type: QuestionType) -> CGFloat {
        switch type {
        case .textField:
            return CGFloat.init(80)
        case .radioBtn, .checkbox, .radioBtnWithInput, .checkboxWithInput, .switchBtn:
            return CGFloat.init(80)
        case .termsSwitchBtn:
            return CGFloat.init(80)
        case .textArea:
            return 200.0
        case .dropdown:
            return 80.0
        }
    }
    
}

class IpadQuestionsAnswersTableRowHeightCalculator: QuestionsAnswersTableRowHeightCalculating {
    
    func getOneRowHeight(componentType type: QuestionType) -> CGFloat {
        switch type {
        case .textField:
            return 90.0
        case .radioBtn, .checkbox, .radioBtnWithInput, .checkboxWithInput, .switchBtn:
            return 60.0
        case .termsSwitchBtn:
            return 60.0
        case .textArea:
            return 200.0
        case .dropdown:
            return 80
        }
        
    }
    
}
