//
//  QuestionsAnswersTableRowHeightCalculator.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 19/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class QuestionsAnswersTableRowHeightCalculator {
    
    func getOneRowHeightRegardingDevice(componentType type: QuestionType) -> CGFloat {
        guard let deviceType = getDeviceType() else {fatalError("unknown device type!")}
        if deviceType == .iPad {
            return getIpadRowHeightFor(componentType: type)
        } else {
            return getIphoneRowHeightFor(componentType: type)
        }
    }
    
    func getIpadRowHeightFor(componentType type: QuestionType) -> CGFloat {
        switch type {
        case .textField:
            return CGFloat.init(90)
        case .radioBtn, .checkbox, .radioBtnWithInput, .checkboxWithInput, .switchBtn:
            return CGFloat.init(60)
        case .termsSwitchBtn:
            return CGFloat.init(30)
        default:
            return 0.0
        }
    }
    
    func getIphoneRowHeightFor(componentType type: QuestionType) -> CGFloat {
        switch type {
        case .textField:
            return CGFloat.init(80)
        case .radioBtn, .checkbox, .radioBtnWithInput, .checkboxWithInput, .switchBtn:
            return CGFloat.init(50)
        case .termsSwitchBtn:
            return CGFloat.init(30)
        default:
            return 0.0
        }
    }
    
    func getHeadlineHeightForDeviceType() -> CGFloat {
        guard let deviceType = getDeviceType() else {
            return CGFloat(0)
        }
        if deviceType == DeviceType.iPhone {
            return CGFloat.init(44)
        } else if deviceType == DeviceType.iPad {
            return CGFloat.init(60)
        }
        return CGFloat(0)
    }
    
    func getFooterHeightForDeviceType() -> CGFloat {
        guard let deviceType = getDeviceType() else {
            return CGFloat(0)
        }
        if deviceType == DeviceType.iPhone {
            return CGFloat.init(60)
        } else if deviceType == DeviceType.iPad {
            return CGFloat.init(80)
        }
        return CGFloat(0)
    }
}




//

protocol QuestionsAnswersTableRowHeightCalculating {
    func getOneRowHeight(componentType type: QuestionType) -> CGFloat
}

class IphoneQuestionsAnswersTableRowHeightCalculator: QuestionsAnswersTableRowHeightCalculating {
    
    func getOneRowHeight(componentType type: QuestionType) -> CGFloat {
        switch type {
        case .textField:
            return CGFloat.init(80)
        case .radioBtn, .checkbox, .radioBtnWithInput, .checkboxWithInput, .switchBtn:
            return CGFloat.init(50)
        case .termsSwitchBtn:
            return CGFloat.init(30)
        default:
            return 0.0
        }
    }
    
}

class IpadQuestionsAnswersTableRowHeightCalculator: QuestionsAnswersTableRowHeightCalculating {
    
    func getOneRowHeight(componentType type: QuestionType) -> CGFloat {
        switch type {
        case .textField:
            return CGFloat.init(90)
        case .radioBtn, .checkbox, .radioBtnWithInput, .checkboxWithInput, .switchBtn:
            return CGFloat.init(60)
        case .termsSwitchBtn:
            return CGFloat.init(30)
        default:
            return 0.0
        }
    }
    
}


protocol QuestionsAnswersTableViewHeaderFooterCalculating {
    func getHeaderHeight() -> CGFloat
    func getFooterHeight() -> CGFloat
}

class IphoneQuestionsAnswersTableViewHeaderFooterCalculator: QuestionsAnswersTableViewHeaderFooterCalculating {
    
    func getHeaderHeight() -> CGFloat {
        return CGFloat.init(44)
    }
    
    func getFooterHeight() -> CGFloat {
        return CGFloat.init(60)
    }
}

class IpadQuestionsAnswersTableViewHeaderFooterCalculator: QuestionsAnswersTableViewHeaderFooterCalculating {
    
    func getHeaderHeight() -> CGFloat {
        return CGFloat.init(60)
    }
    
    func getFooterHeight() -> CGFloat {
        return CGFloat.init(80)
    }
}



