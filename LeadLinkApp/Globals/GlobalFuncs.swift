//
//  GlobalFuncs.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 11/04/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import AVFoundation
import ScanditBarcodeScanner

enum DeviceType {
    case iPhone
    case iPad
}

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

func getDeviceType() -> DeviceType? {
    if UIDevice.current.userInterfaceIdiom == .phone {
        return DeviceType.iPhone
    } else if UIDevice.current.userInterfaceIdiom == .pad {
        return DeviceType.iPad
    }
    return nil
}

func trimmedToSixCharactersCode(code: String) -> String {
    let startPosition = code.count - 6
    let trimToSixCharactersCode = NSString(string: code).substring(from: startPosition)
    //    print("trimed code = \(trimToSixCharactersCode), with code = \(code)")
    return trimToSixCharactersCode
}

func getCameraDeviceDirection() -> SBSCameraFacingDirection? {
//    if UIDevice.current.userInterfaceIdiom == .phone {
//        return SBSCameraFacingDirection.back
//    } else if UIDevice.current.userInterfaceIdiom == .pad {
//        return SBSCameraFacingDirection.front
//    }
//    return nil
    return .back
}

func getAnswersWithoutTermsSwitch(questions: [Question], answers: [MyAnswer]) -> [MyAnswer] {
    
    if let termsQuestionId = (questions.filter({$0.type == "termsSwitchBtn"}).first)?.id {
        let newAnswers = answers.filter({$0.questionId != termsQuestionId})
        return newAnswers
    } else {
        return answers
    }
    
}
