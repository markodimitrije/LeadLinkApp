//
//  TextAreaViewModel.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class TextAreaViewModel: NSObject, QuestionPageViewModelProtocol {
    
    private var question: PresentQuestion
    private var answer: MyAnswer?
    private var code: String
    
    private var view: UIView!
    
    init(questionInfo: PresentQuestionInfoProtocol, textAreaViewFactory: GetViewProtocol) {
        self.question = questionInfo.getQuestion()
        self.answer = questionInfo.getAnswer()
        self.code = questionInfo.getCode()
        super.init()
        self.view = textAreaViewFactory.getView()
        self.view.tag = questionInfo.getQuestion().id
        self.view.findViews(subclassOf: UITextView.self).first!.delegate = self
    }
    
    func getView() -> UIView {
        return self.view
    }
    
    func getActualAnswer() -> MyAnswer? {
        let text = view.findViews(subclassOf: UITextView.self).first!.text
        let result = (text != self.question.description) ? text : ""
        if answer != nil {
            answer?.content = [result ?? ""]
        } else {
            answer = MyAnswer(question: question, code: code, content: [result ?? ""], optionIds: nil)
        }
        return answer
    }
}

extension TextAreaViewModel: UITextViewDelegate {
     
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == question.description {
            self.deletePlaceholderAndSetTxtColorToBlack(textView: textView)
        }
    }
    private func deletePlaceholderAndSetTxtColorToBlack(textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
}
