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
    private var questions: [SurveyQuestion]
    private var webViewsAndViewSizesProvider: WebQuestionsViewProviding
    
    private var webQuestionIdsViewSizes: [Int: CGSize] {
        return self.webViewsAndViewSizesProvider.webQuestionIdsToViewSizes
    }
    private var localComponents: LocalComponents {return viewController.localComponents}
    
    lazy private var dataSourceHelper = QuestionsDataSourceAndDelegateHelper(questions: self.questions, localComponents: viewController.localComponents)
    
    init(viewController: QuestionsAnswersVC, questions: [SurveyQuestion], webViewsAndViewSizesProvider: WebQuestionsViewProviding) {
        self.viewController = viewController
        self.questions = questions
        self.webViewsAndViewSizesProvider = webViewsAndViewSizesProvider
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if sectionIsFirstInTable(section: section) {
            return 0.0
        }
        return tableHeaderFooterCalculator.getHeaderHeight()
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        header.textLabel?.frame = header.frame
        header.textLabel?.textAlignment = .left
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section != (tableView.numberOfSections - 1) else {return nil}
        return dataSourceHelper.footerView(sectionIndex: section, tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if sectionIsLastInTable(section: section) {
            return 0.0
        }
        return tableHeaderFooterCalculator.getFooterHeight()
    }
    
    private func sectionIsLastInTable(section: Int) -> Bool {
        return dataSourceHelper.numberOfDifferentGroups() - 1 == section // - 1 cause of ("" and nil) groups
    }
    
    private func sectionIsFirstInTable(section: Int) -> Bool {
        return section == 0
    }
}
