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
        view.backgroundColor = .red
        cell.addSubview(view)
        
        // remove red view
        delay(1.0) {
            cell.subviews.last?.removeFromSuperview()
        }
    }
}
