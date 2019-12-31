//
//  LabelTextField_ViewModel.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 16/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class LabelTextField_ViewModel: NSObject, QuestionPageViewModelProtocol {
    
    private var question: QuestionProtocol
    private var answer: MyAnswerProtocol?
    private var code: String
    
    private var myView: UIView!
    
    init(surveyQuestion: SurveyQuestionProtocol, viewFactory: GetViewProtocol) {
        self.question = surveyQuestion.getQuestion()
        self.answer = surveyQuestion.getAnswer()
        self.code = surveyQuestion.getCode()
        super.init()
        self.myView = viewFactory.getView()
        self.myView.tag = surveyQuestion.getQuestion().qId
        self.myView.findViews(subclassOf: UITextField.self).first!.delegate = self
    }
    
    func getView() -> UIView {
        return self.myView
    }
    
    func getActualAnswer() -> MyAnswerProtocol? {
        let text = myView.findViews(subclassOf: UITextField.self).first!.text
        let result = (text != self.question.qDesc) ? text : ""
        if answer != nil {
            answer?.content = [result ?? ""]
        } else {
            answer = MyAnswer(question: question, code: code, content: [result ?? ""], optionIds: nil)
        }
        return answer
    }
}

extension LabelTextField_ViewModel: UITextFieldDelegate {
     
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == question.qDesc {
            self.deletePlaceholderAndSetTxtColorToBlack(textField: textField)
        }
    }
    
    private func deletePlaceholderAndSetTxtColorToBlack(textField: UITextField) {
        if textField.textColor == .lightGray {
            textField.text = nil
            textField.textColor = .black
        }
    }
}
