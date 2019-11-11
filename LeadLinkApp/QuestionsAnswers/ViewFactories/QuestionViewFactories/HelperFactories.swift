//
//  HelperFactories.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 11/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

class HelperFactories {
    
    var sameComponentsFactory: SameComponentsFactory
    var questionViewWithHeadlineLabelFactory: QuestionViewWithHeadlineLabelFactory
    var bag: DisposeBag
    var delegate: UITextViewDelegate?
    
    init(questionsAnswersCalculator: QuestionsAnswersTableWidthCalculating,
         bag: DisposeBag,
         delegate: UITextViewDelegate?) {
        
        self.sameComponentsFactory = SameComponentsFactory(questionsWidthProvider: questionsAnswersCalculator)
        self.questionViewWithHeadlineLabelFactory = QuestionViewWithHeadlineLabelFactory()
        self.delegate = delegate
        self.bag = bag
    }
    
    init(sameComponentsFactory: SameComponentsFactory,
         questionViewWithHeadlineLabelFactory: QuestionViewWithHeadlineLabelFactory,
         bag: DisposeBag,
         delegate: UITextViewDelegate?) {
        
        self.sameComponentsFactory = sameComponentsFactory
        self.questionViewWithHeadlineLabelFactory = questionViewWithHeadlineLabelFactory
        self.bag = bag
        self.delegate = delegate
    }
}
