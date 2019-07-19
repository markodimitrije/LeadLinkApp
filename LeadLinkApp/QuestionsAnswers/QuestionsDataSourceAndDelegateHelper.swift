//
//  QuestionsDataSourceAndDelegateHelper.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 07/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

struct QuestionsDataSourceAndDelegateHelper {
    
    private var orderedQuestions = [PresentQuestion]()
    private var localComponents: LocalComponents
    
    lazy private var orderedGroups = orderedQuestions.map { question -> String in
            if itemHasNoGroup(question: question) {
                return SectionType.noGroupAssociated.rawValue
            } else {
                return question.group!
            }
        }.unique() + [SectionType.localComponentsGroupName.rawValue]
    
    init(questions: [SurveyQuestion], localComponents: LocalComponents) {
        self.orderedQuestions = questions.map {$0.question}.sorted(by: <)
        self.localComponents = localComponents
    }
    
    mutating func numberOfDifferentGroups() -> Int {
        return orderedGroups.unique().count
    }
    
    mutating func groupNames() -> [String] {
        return orderedGroups

    }
    
    mutating func questionsInGroupWith(index: Int) -> [PresentQuestion]? {
        if index == orderedGroups.count - 1 {return nil} // last section nema questions, u njemu je i SAVE BTN
        if orderedGroups[index] != SectionType.noGroupAssociated.rawValue {
            return questionsInGroup(withIndex: index)
        } else {
            return questionsWithNoGroup()
        }
    }
    
    mutating func itemsInGroupWith(index: Int) -> Int {
        guard let questions = questionsInGroupWith(index: index) else {
            return localComponents.componentsInOrder.count
        }
        return questions.count
    }
    
    mutating func questionId(indexPath: IndexPath) -> Int? {
        guard let questions = questionsInGroupWith(index: indexPath.section) else {return nil}
        return questions[indexPath.row].id
    }
    
    mutating private func questionsInGroup(withIndex index: Int) -> [PresentQuestion] {
        let group = orderedGroups[index]
        let questions = orderedQuestions.filter {$0.group == group}.sorted(by: <)
        return questions
    }
    
    mutating private func questionsWithNoGroup() -> [PresentQuestion] {
        return orderedQuestions.filter {$0.group == nil || $0.group == ""}
    }
    
    private func itemHasNoGroup(question: PresentQuestion) -> Bool {
        return question.group == nil || question.group == ""
    }
    
    func footerView(sectionIndex: Int, tableView: UITableView) -> UIView {
        let size = footerViewSize(sectionIndex: sectionIndex, tableView: tableView)
        let rect = CGRect.init(origin: CGPoint.zero, size: size) // hard-coded ??
        return QuestionGroupFooterView.init(frame: rect)
    }
    
    private func footerViewSize(sectionIndex: Int, tableView: UITableView) -> CGSize {
        return CGSize.init(width: tableView.bounds.width,
                           height: tableRowHeightCalculator.getFooterHeightForDeviceType()
        )
    }
    
}
