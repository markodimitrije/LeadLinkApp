//
//  SurveyQuestionProtocol.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 31/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol ViewInfoProtocol {}

protocol SurveyQuestionProtocol: ViewInfoProtocol {
    func getQuestion() -> QuestionProtocol
    func getAnswer() -> MyAnswerProtocol?
    func getCode() -> String
}
