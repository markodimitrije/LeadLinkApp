//
//  QuestionType.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 30/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

enum QuestionType: String {
    case radioBtn = "radio"//"radioBtn"
    case checkbox = "checkbox"
    case radioBtnWithInput = "radioBtnWithInput"
    case checkboxSingleWithInput = "checkbox_single_with_input"
    case checkboxMultipleWithInput = "checkbox_with_input"
    case switchBtn = "switchBtn"
    case textField = "text"//"textField"
    case textArea = "textarea"
    case dropdown = "dropdown"// case textWithOptions = "textWithOptions"
    case termsSwitchBtn = "termsSwitchBtn"
}
