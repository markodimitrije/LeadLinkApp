//
//  ViewInfoProvider.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 07/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class ViewInfoProvider {
    
    private var campaign: CampaignProtocol
    private var questionsInfos = [SurveyQuestionProtocol]()
    private var code: String
    private var orderedQuestions = [QuestionProtocol]()
    
    lazy private var orderedGroups = orderedQuestions.map { question -> String in
            if itemHasNoGroup(question: question) {
                return ""
            } else {
                return question.qGroup
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
    
    init(campaign: CampaignProtocol, questions: [SurveyQuestionProtocol], code: String) {
        self.campaign = campaign
        self.questionsInfos = questions
        self.code = code
        self.orderedQuestions = questions.map {$0.getQuestion() as! Question}.sorted(by: <)
    }
    
    // MARK:- API
    
    func getViewInfos() -> [ViewInfoProtocol] {
        var items = [ViewInfoProtocol]()
        let questionsInGroups = orderedGroups.map(getQuestionsFor)
        _ = orderedGroups.enumerated().map { (index, groupName) in

            let groupViewInfo = GroupViewInfo(title: groupName)
            items.append(groupViewInfo)

            let groupQuestions = questionsInGroups[index]

            let questionInfos: [SurveyQuestion] = groupQuestions.map { presentQuestion in
                    return SurveyQuestion(question: presentQuestion.getQuestion(),
                                               answer: presentQuestion.getAnswer(),
                                               code: self.code)
                }
            items.append(contentsOf: questionInfos)
        }
        return items
    }
    
    // MARK:- Privates
    private func getQuestionsFor(groupName name: String) -> [SurveyQuestionProtocol] {
        return questionsInfos.filter({$0.getQuestion().qGroup == name})
    }
    
    private func itemHasNoGroup(question: QuestionProtocol) -> Bool {
        return question.qGroup == ""
    }
    
    private func footerViewSize(sectionIndex: Int, tableView: UITableView) -> CGSize {
        return CGSize.init(width: tableView.bounds.width,
                           height: tableHeaderFooterCalculator.getFooterHeight()
        )
    }
    
    private func getNameForLastGroup() -> String {
        return (campaign.settings?.optIn != nil) ? "Privacy policy" : ""
    }
    
}
