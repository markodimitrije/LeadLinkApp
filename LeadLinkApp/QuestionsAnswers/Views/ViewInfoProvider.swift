//
//  ViewInfoProvider.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 07/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class ViewInfoProvider {
    
    private var code: String
    private var surveyQuestions = [SurveyQuestion]()
    private var orderedQuestions = [PresentQuestion]()
    
    lazy private var orderedGroups = orderedQuestions.map { question -> String in
            if itemHasNoGroup(question: question) {
                return ""
            } else {
                return question.group!
            }
        }.unique() + [getNameForLastGroup()] //[QuestionsAnswersSectionType.localComponentsGroupName.rawValue]

    // to test group reordering:
//    lazy private var orderedGroups = [QuestionsAnswersSectionType.localComponentsGroupName.rawValue] +
//
//        orderedQuestions.map { question -> String in
//
//            if itemHasNoGroup(question: question) {
//                return QuestionsAnswersSectionType.noGroupAssociated.rawValue
//            } else {
//                return question.group!
//            }
//
//        }.unique()
    
    init(questions: [SurveyQuestion], code: String) {
        self.surveyQuestions = questions
        self.code = code
        self.orderedQuestions = questions.map {$0.question}.sorted(by: <)
    }
    
    // MARK:- API
    
    func getQuestionsFor(groupName name: String) -> [SurveyQuestion] {
        return surveyQuestions.filter({$0.question.group == name})
    }
    
    func getViewInfos() -> [ViewInfoProtocol] {
        var items = [ViewInfoProtocol]()
        let questionsInGroups = orderedGroups.map(getQuestionsFor)
        _ = orderedGroups.enumerated().map { (index, groupName) in

            let groupViewInfo = GroupViewInfo(title: groupName)
            items.append(groupViewInfo)

            let groupQuestions = questionsInGroups[index]

            let questionInfos: [PresentQuestionInfo] = groupQuestions.map { presentQuestion in
                    return PresentQuestionInfo(question: presentQuestion.question,
                                               answer: presentQuestion.answer,
                                               code: self.code)
                }
            items.append(contentsOf: questionInfos)
        }
        return items
    }
    
    // MARK:- Privates
    private func itemHasNoGroup(question: PresentQuestion) -> Bool {
        return question.group == nil || question.group == ""
    }
    
    private func footerViewSize(sectionIndex: Int, tableView: UITableView) -> CGSize {
        return CGSize.init(width: tableView.bounds.width,
                           height: tableHeaderFooterCalculator.getFooterHeight()
        )
    }
    
    private func getNameForLastGroup() -> String {
        return "Privacy policy"
    }
    
}
