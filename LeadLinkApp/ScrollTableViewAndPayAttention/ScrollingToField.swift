//
//  ScrollingToField.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 23/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

protocol ScrollingToField {
    func scrollTo(question: PresentQuestion)
}

class TableViewScroller: ScrollingToField {
    
    private var tableView: UITableView
    private var questions: [PresentQuestion]
    private var helper: QuestionsDataSourceAndDelegateHelper
    
    init(tableView: UITableView, questions: [PresentQuestion], helper: QuestionsDataSourceAndDelegateHelper) {
        self.tableView = tableView
        self.questions = questions
        self.helper = helper
    }
    
    func scrollTo(question: PresentQuestion) {
        
        let ip = helper.getIndexPath(forQuestion: question)
        self.tableView.scrollToRow(at: ip, at: .top, animated: true)
        
    }
}
