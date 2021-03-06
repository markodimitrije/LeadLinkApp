//
//  TermsSwitchBtnViewModel.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 11/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class TermsSwitchBtnViewModel: QuestionPageViewModelProtocol {
    private var question: QuestionProtocol
    private var answer: MyAnswerProtocol?
    private let code: String
    private let myView: UIView
    func getView() -> UIView {
        return self.myView
    }
    
    func getActualAnswer() -> MyAnswerProtocol? {
        let switchBtn = myView.findViews(subclassOf: UISwitch.self).first!
        let content = ["\(switchBtn.isOn)"]
        if answer != nil {
            answer!.content = content
        } else {
            answer = MyAnswer(question: question, code: code, content: content, optionIds: nil)
        }
        return answer
    }
    init(surveyQuestion: SurveyQuestionProtocol) {
        self.question = surveyQuestion.getQuestion()
        self.answer = surveyQuestion.getAnswer()
        self.code = surveyQuestion.getCode()
        let isOn = !(self.answer?.content.isEmpty ?? true)
        let factory = TermsSwitchBtnViewFactory(surveyQuestion: surveyQuestion, isOn: isOn)
        self.myView = factory.getView()
        self.myView.tag = surveyQuestion.getQuestion().qId
    }
    
}
