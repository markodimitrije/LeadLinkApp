//
//  QuestionPageGetViewItemsWorkerFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 19/02/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol QuestionPageGetViewItemsWorkerFactoryProtocol {
    func make(surveyInfo: SurveyInfo) -> QuestionPageGetViewItemsWorker
}

class QuestionPageGetViewItemsWorkerFactory: QuestionPageGetViewItemsWorkerFactoryProtocol {
    func make(surveyInfo: SurveyInfo) -> QuestionPageGetViewItemsWorker {
        let surveyQuestions = SurveyQuestionsLoader(surveyInfo: surveyInfo).getSurveyQuestions()
        let helper = ViewInfoProvider(campaign: surveyInfo.campaign,
                                      questions: surveyQuestions,
                                      code: surveyInfo.code)
        let viewInfos = helper.getViewInfos()

        let getViewItemsWorker = QuestionPageGetViewItemsWorker(viewInfos: viewInfos,
                                                                campaign: surveyInfo.campaign)
        return getViewItemsWorker
    }
}
