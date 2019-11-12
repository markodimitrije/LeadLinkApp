//
//  LabelWithTxtFieldFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 29/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

class LabelWithTxtFieldFactory {
    
    var sameComponentsFactory: SameComponentsFactory
    var questionViewWithHeadlineLabelFactory: QuestionViewWithHeadlineLabelFactory
    var bag: DisposeBag
    var delegate: UITextViewDelegate?
    
    init(sameComponentsFactory: SameComponentsFactory,
         questionViewWithHeadlineLabelFactory: QuestionViewWithHeadlineLabelFactory,
         bag: DisposeBag,
         delegate: UITextViewDelegate?) {
        
        self.sameComponentsFactory = sameComponentsFactory
        self.questionViewWithHeadlineLabelFactory = questionViewWithHeadlineLabelFactory
        self.bag = bag
        self.delegate = delegate
    }
    
    func getLabelAndTextField(question: PresentQuestion, answer: Answering?, frame: CGRect) -> (ViewStacker, [LabelAndTextField]) {

        let stackerView = self.viewStackerWithLblAndTextField(questionWithAnswers: [(question, answer)], frame: frame)

        let views = stackerView.components.flatMap { view -> [LabelAndTextField] in
            return (view as? OneRowStacker)?.components as? [LabelAndTextField] ?? [ ]
        }

        _ = views.enumerated().map { $0.element.textField.tag = $0.offset } // dodeli svakome unique TAG

        return (stackerView, views)

    }
    
    private func viewStackerWithLblAndTextField(questionWithAnswers: [(PresentQuestion, Answering?)], frame: CGRect) -> ViewStacker {
        
        //return produceStackWithSameComponents(ofType: RadioBtnView.self, count: question.options.count, inOneRow: 3)!
        return sameComponentsFactory.createStackWithSameComponents(ofType: LabelAndTextField.self,
            //componentsTotalCount: questionWithAnswers.count,
            //componentsTotalCount: 2,
            //elementsInOneRow: 2)!
            componentsTotalCount: 1,
            elementsInOneRow: 1)!
    }
}
