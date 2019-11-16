//
//  LabelWithTxtViewFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 29/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

class LabelWithTextViewFactory {
    
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
    
    func getLabelAndTextView(question: PresentQuestion, answer: Answering?, frame: CGRect) -> (ViewStacker, [LabelAndTextView]) {
        
        let stackerView = self.viewStackerWithLblAndTextView(questionWithAnswers: [(question, answer)],
                                                             frame: frame)
        
        let views = stackerView.components.flatMap { view -> [LabelAndTextView] in
            return (view as? OneRowStacker)?.components as? [LabelAndTextView] ?? [ ]
        }
        
        _ = views.enumerated().map { $0.element.textView.tag = question.id } // dodeli mu unique TAG kakav je questionId !!
        
        return (stackerView, views)
        
    }
    
    private func viewStackerWithLblAndTextView(questionWithAnswers: [(PresentQuestion, Answering?)], frame: CGRect) -> ViewStacker {
        
        var contentHeight = frame.height
        
        let contentCounts = questionWithAnswers.map {$0.1?.content.count ?? 0}
        let maxContentCount = contentCounts.sorted(by: >).first
        
        if let maxContentCount = maxContentCount, maxContentCount > 1 {
            contentHeight = CGFloat(maxContentCount * 22) // sta je ovo ??!?!? hard-coded ??
        }
        
        let viewStacker = sameComponentsFactory.createStackWithSameComponents(ofType: LabelAndTextView.self, componentsTotalCount: questionWithAnswers.count, elementsInOneRow: 1)!
        viewStacker.frame.size.height = contentHeight
        
        return viewStacker
        
    }
}
