//
//  WebQuestionsViewProviding.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 19/08/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

protocol WebQuestionsViewProviding {
    var webQuestionViews: [Int: UIView] {get set}
    var webQuestionIdsToViewSizes: [Int: CGSize] {get set}
}

class WebViewsAndViewSizesProvider: WebQuestionsViewProviding {
    
    var webQuestionViews = [Int: UIView]()
    var webQuestionIdsToViewSizes = [Int: CGSize]()
    
    private var questions = [SurveyQuestion]()
    private var viewmodels: [Int: Questanable]
    private var viewStackerFactory: ViewStackerFactory
    
    init(questions: [SurveyQuestion], viewmodels: [Int: Questanable], viewStackerFactory: ViewStackerFactory) {
        
        self.questions = questions
        self.viewmodels = viewmodels
        self.viewStackerFactory = viewStackerFactory
        
        self.loadWebQuestionViewsAndComponentSizes()
    }
    
    private func loadWebQuestionViewsAndComponentSizes() {
        
        let orderedQuestions = questions.sorted(by: {$0.question.order < $1.question.order})
        
        _ = orderedQuestions.map { surveyQuestion -> Void in
            let questionId = surveyQuestion.question.id
            
            guard let viewmodel = viewmodels[questionId] else {return}
            
            let questionView = viewStackerFactory.getStackerView(surveyQuestion: surveyQuestion,
                                                                 viewmodel: viewmodel)
            webQuestionViews[questionId] = questionView
            webQuestionIdsToViewSizes[questionId] = questionView.bounds.size
            
        }
        
    }
}
