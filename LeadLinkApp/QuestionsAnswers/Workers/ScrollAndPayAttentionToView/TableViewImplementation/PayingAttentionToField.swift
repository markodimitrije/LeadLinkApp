//
//  PayingAttentionToField.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 23/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

protocol PayingAttentionToField {
    func payAttentionTo(question: QuestionProtocol)
}

class ScrollViewPayingAttentioner: PayingAttentionToField {
    
    private var scrollView: QuestionsScrollView
    private var questions: [QuestionProtocol]
    
    init(scrollView: QuestionsScrollView, questions: [QuestionProtocol]) {
        self.scrollView = scrollView
        self.questions = questions
    }
    
    func payAttentionTo(question: QuestionProtocol) {
        if question.qType == .termsSwitchBtn {
            applyColor(question: question)
        } else {
            activateTextField(question: question)
        }
    }
    
    private func activateTextField(question: QuestionProtocol) {
        
        guard let textField = scrollView.getQuestionViewTextControl(question: question) else {
            return
        }
        textField.becomeFirstResponder()
    }
    
    private func applyColor(question: QuestionProtocol) {
        
        guard let termsView = scrollView.getQuestionView(question: question) else {return}

        // show red view
        let view = UIView.init(frame: termsView.bounds)
        view.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        termsView.addSubview(view)

        // remove red view
        delay(1.0) {
            termsView.subviews.last?.removeFromSuperview()
        }
    }
}

protocol QuestionsScrollViewProtocol {
    func getFirstResponder() -> UIView?
    func getQuestionView(question: PresentQuestion) -> UIView?
}

class QuestionsScrollView: UIScrollView {
    
    private var stackView: UIStackView {
        return self.subviews.first as! UIStackView
    }
    
    func getFirstResponder() -> UIView? {
        if let activeTextView = stackView.findViews(subclassOf: UITextView.self).first(where: {$0.isFirstResponder}) {
            return activeTextView
        }
        if let activeTextField = stackView.findViews(subclassOf: UITextField.self).first(where: {$0.isFirstResponder}) {
            return activeTextField
        }
        return nil
    }
    
    func getQuestionView(question: QuestionProtocol) -> UIView? {
        self.stackView.subviews.first(where: {$0.tag == question.qId})
    }
    
    func getQuestionViewTextControl(question: QuestionProtocol) -> UIView? {
        guard let questionView = getQuestionView(question: question) else {
            return nil
        }
        if let textView = questionView.findViews(subclassOf: UITextView.self).first {
            return textView
        }
        return questionView.findViews(subclassOf: UITextField.self).first
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
