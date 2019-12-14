//
//  PayingAttentionToField.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 23/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

protocol PayingAttentionToField {
    func payAttentionTo(question: PresentQuestion)
}

class TableViewPayingAttentioner: PayingAttentionToField {
    
    private var tableView: UITableView
    private var questions: [PresentQuestion]
    private var helper: QuestionsDataSourceAndDelegateHelper
    
    init(tableView: UITableView, questions: [PresentQuestion], helper: QuestionsDataSourceAndDelegateHelper) {
        self.tableView = tableView
        self.questions = questions
        self.helper = helper
    }
    
    func payAttentionTo(question: PresentQuestion) {
        
        guard let ip = helper.getIndexPath(forQuestion: question) else {return}
        
        if question.type == .textField {
            activateTextField(ip: ip)
        } else {
            applyColor(ip: ip)
        }
        
    }
    
    private func activateTextField(ip: IndexPath) {
        
        guard let cell = self.tableView.cellForRow(at: ip) else { return }
        
        let allTextFields = cell.findViews(subclassOf: UITextField.self)
        allTextFields.first?.becomeFirstResponder()
    }
    
    private func applyColor(ip: IndexPath) {
        
        var cell: UITableViewCell
        guard self.tableView.cellForRow(at: ip) != nil else {return}
        cell = self.tableView.cellForRow(at: ip)!
        
        // show red view
        let view = UIView.init(frame: cell.bounds)
        //view.backgroundColor = .red
        view.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        cell.addSubview(view)
        
        // remove red view
        delay(1.0) {
            cell.subviews.last?.removeFromSuperview()
        }
    }
}

class ScrollViewPayingAttentioner: PayingAttentionToField {
    
    private var scrollView: QuestionsScrollView
    private var questions: [PresentQuestion]
    
    init(scrollView: QuestionsScrollView, questions: [PresentQuestion]) {
        self.scrollView = scrollView
        self.questions = questions
    }
    
    func payAttentionTo(question: PresentQuestion) {
        if question.type == .termsSwitchBtn {
            applyColor(question: question)
        } else {
            activateTextField(question: question)
        }
    }
    
    private func activateTextField(question: PresentQuestion) {
        
        guard let textField = scrollView.getQuestionViewTextControl(question: question) else {
            return
        }
        textField.becomeFirstResponder()
    }
    
    private func applyColor(question: PresentQuestion) {
        
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
    
    func getQuestionView(question: PresentQuestion) -> UIView? {
        self.stackView.subviews.first(where: {$0.tag == question.id})
    }
    
    func getQuestionViewTextControl(question: PresentQuestion) -> UIView? {
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