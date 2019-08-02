//
//  ViewStackerFactory.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 11/04/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewStackerFactory {
    
    private var questionsWidthProvider: QuestionsAnswersTableWidthCalculating
    private var bag: DisposeBag
    private var delegate: UITextViewDelegate?
    
    init(questionsWidthProvider: QuestionsAnswersTableWidthCalculating, bag: DisposeBag, delegate: UITextViewDelegate?) {
        self.questionsWidthProvider = questionsWidthProvider
        self.bag = bag
        self.delegate = delegate
    }
    
    func getStackerView(surveyQuestion: SurveyQuestion, viewmodel: Questanable) -> UIView {
        
        let questionViewFactory: MyQuestionViewFactory = MyQuestionViewFactory(
            sameComponentsFactory: SameComponentsFactory(questionsWidthProvider: questionsWidthProvider),
            questionViewHeadlineLabelFactory: QuestionViewWithHeadlineLabelFactory(),
            bag: bag,
            delegate: delegate)
        
        let height = tableRowHeightCalculator.getOneRowHeight(componentType: surveyQuestion.question.type)
        let fr = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: questionsWidthProvider.getWidth(),
                                                                     height: height))
        
        return questionViewFactory.makeViewStacker(surveyQuestion: surveyQuestion, frame: fr, viewmodel: viewmodel)!
        
    }
    
}
