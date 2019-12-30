//
//  LabelTextView_ViewModel.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class LabelTextView_ViewModel: NSObject, QuestionPageViewModelProtocol {
    
    private var question: QuestionProtocol
    private var answer: MyAnswerProtocol?
    private var code: String
    
    private var myView: UIView!
    
    init(questionInfo: PresentQuestionInfoProtocol, viewFactory: GetViewProtocol) {
        self.question = questionInfo.getQuestion()
        self.answer = questionInfo.getAnswer()
        self.code = questionInfo.getCode()
        super.init()
        self.myView = viewFactory.getView()
        self.myView.tag = questionInfo.getQuestion().qId
        self.myView.findViews(subclassOf: UITextView.self).first!.delegate = self
    }
    
    func getView() -> UIView {
        return self.myView
    }
    
    func getActualAnswer() -> MyAnswerProtocol? {
        let text = myView.findViews(subclassOf: UITextView.self).first!.text
        let result = (text != self.question.qDesc) ? text : ""
        if answer != nil {
            answer?.content = [result ?? ""]
        } else {
            answer = MyAnswer(question: question, code: code, content: [result ?? ""], optionIds: nil)
        }
        return answer
    }
}

extension LabelTextView_ViewModel: UITextViewDelegate {
     
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == question.qDesc {
            self.deletePlaceholderAndSetTxtColorToBlack(textView: textView)
        }
    }
    private func deletePlaceholderAndSetTxtColorToBlack(textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
