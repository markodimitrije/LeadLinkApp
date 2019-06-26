//
//  QuestionsAnswersDelegate.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 26/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class QuestionsAnswersDelegate: NSObject, UITableViewDelegate, UITextFieldDelegate {
    
    private var viewController: QuestionsAnswersVC
    
    private var webQuestionIdsViewSizes: [Int: CGSize] {return viewController.webQuestionIdsToViewSizes}
    private var localComponents: LocalComponents {return viewController.localComponents}
    
    lazy private var dataSourceHelper = QuestionsDataSourceAndDelegateHelper(questions: viewController.questions, localComponents: viewController.localComponents)
    
    init(viewController: QuestionsAnswersVC) {
        self.viewController = viewController
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let questionId = dataSourceHelper.questionId(indexPath: indexPath) else {
            let localComponentsSize = LocalComponentsSize()
            let view = localComponents.componentsInOrder[indexPath.row]
            let (_, height) = localComponentsSize.getComponentWidthAndHeight(type: type(of: view))
            return height
        }
        
        let cellHeight = webQuestionIdsViewSizes[questionId]?.height ?? CGFloat.init(80)
        
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section != (tableView.numberOfSections - 1) else {return nil}
        return dataSourceHelper.footerView(sectionIndex: section, tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableRowHeightCalculator.getFooterHeightForDeviceType()
    }
    
}
