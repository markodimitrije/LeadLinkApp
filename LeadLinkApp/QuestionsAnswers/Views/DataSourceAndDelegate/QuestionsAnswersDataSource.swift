//
//  QuestionsAnswersDataSource.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 26/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class QuestionsAnswersDataSource: NSObject, UITableViewDataSource {
    
    private var viewController: QuestionsAnswersVC
    private var questions: [SurveyQuestion]
    private var webViewsAndViewSizesProvider: WebQuestionsViewProviding
    
    private var webQuestionViews: [Int: UIView] {
        return webViewsAndViewSizesProvider.webQuestionViews
    }
    private var webQuestionIdsViewSizes: [Int: CGSize] {
        return webViewsAndViewSizesProvider.webQuestionIdsToViewSizes
    }
    private var localComponents: LocalComponentsViewFactory {return viewController.localComponents}
    
    lazy private var dataSourceHelper = QuestionsDataSourceAndDelegateHelper(questions: self.questions, localComponents: viewController.localComponents)
    
    init(viewController: QuestionsAnswersVC, questions: [SurveyQuestion], webViewsAndViewSizesProvider: WebQuestionsViewProviding) {
        self.viewController = viewController
        self.questions = questions
        self.webViewsAndViewSizesProvider = webViewsAndViewSizesProvider
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { // koliko imas different groups ?
        
        return dataSourceHelper.numberOfDifferentGroups()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceHelper.itemsInGroupWith(index: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSourceHelper.groupNames()[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.removeAllSubviews()
        
        if let questionId = dataSourceHelper.questionId(indexPath: indexPath) {
            populateCellForWebQuestion(cell: cell, questionId: questionId)
        } else {
            populateCellForLocalQuestion(cell: cell, indexPath: indexPath)
        }
        return cell
    }
    
    private func populateCellForWebQuestion(cell: UITableViewCell, questionId: Int) {
        if let stackerView = webQuestionViews[questionId] {
            stackerView.frame = cell.bounds
            cell.addSubview(stackerView)
        }
    }
    
    private func populateCellForLocalQuestion(cell: UITableViewCell, indexPath: IndexPath) {
        let view = localComponents.componentsInOrder[indexPath.row]
        view.center = CGPoint.init(x: cell.bounds.midX, y: cell.bounds.midY)
        cell.addSubview(view)
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
    
}
