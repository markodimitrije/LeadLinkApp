//
//  AnswersUpdater.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 25/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation


protocol AnswersUpdating {
    func updateAnswers() -> [MyAnswerProtocol]
}

class AnswersUpdater: AnswersUpdating {
    
    private var surveyInfo: SurveyInfo
    private var questionsAnswersViewModel: QuestionsAnswersViewModel
    
    init(surveyInfo: SurveyInfo, questionsAnswersViewModel: QuestionsAnswersViewModel) {
        self.surveyInfo = surveyInfo
        self.questionsAnswersViewModel = questionsAnswersViewModel
    }
    
    func updateAnswers() -> [MyAnswerProtocol] {
        
        var answers = self.surveyInfo.answers // contains barcode
        var answerIds = answers.map({$0.id})
        
        func addOrUpdateAnswers(withAnswer answer: MyAnswerProtocol) {
            
            func updateMyAnswers(newAnswer: MyAnswerProtocol) {
                if let index = answerIds.firstIndex(of: newAnswer.id) {
                    answers.remove(at: index)
                }
                answers.append(newAnswer)
                answerIds = answers.map({$0.id})
            }
            
            /*
            if answer.questionType == QuestionType.termsSwitchBtn.rawValue {
                
                updateMyAnswers(newAnswer: answer)
                
            //} else if let content = answer.content.first, content != "" {
            } else {
                updateMyAnswers(newAnswer: answer)
            }
            */
            updateMyAnswers(newAnswer: answer)
        }
        
        answers = questionsAnswersViewModel.getAnswers()
        _ = answers.map { (answer) in
            addOrUpdateAnswers(withAnswer: answer)
        }
        
//        _ = self.questionsAnswersViewModel.childViewmodels.compactMap { viewmodelDict in // transfer
//
//            if let viewmodel = viewmodelDict.value as? Answerable, var answer = viewmodel.answer {
//
//                answer.code = surveyInfo.code
//                addOrUpdateAnswers(withAnswer: answer)
//            }
//
//        }
        
        print("updatedAnswers = \(answers)")
        
        return answers
    }
    
}
