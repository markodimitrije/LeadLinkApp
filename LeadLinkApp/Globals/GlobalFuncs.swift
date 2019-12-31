//
//  GlobalFuncs.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 11/04/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import AVFoundation
import ScanditBarcodeCapture

enum DeviceType {
    case iPhone
    case iPad
}

func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
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

func getCameraDeviceDirection() -> CameraPosition? {
    if UIDevice.current.userInterfaceIdiom == .phone {
        return CameraPosition.worldFacing
    } else if UIDevice.current.userInterfaceIdiom == .pad {
        return CameraPosition.userFacing
    }
    return nil
}

func getAnswersWithoutTermsSwitch(questions: [QuestionProtocol], answers: [MyAnswer]) -> [MyAnswer] {
    
    if let termsQuestionId = (questions.filter({$0.qType == .termsSwitchBtn}).first)?.qId {
        let newAnswers = answers.filter({$0.questionId != termsQuestionId})
        return newAnswers
    } else {
        return answers
    }
    
} // depricated?
