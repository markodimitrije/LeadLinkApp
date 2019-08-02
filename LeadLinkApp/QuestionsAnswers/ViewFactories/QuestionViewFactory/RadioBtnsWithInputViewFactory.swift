//
//  RadioBtnsWithInputViewFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 29/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

class RadioBtnsWithInputViewFactory {
    
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
    
    func getRadioBtnsWithInputView(surveyQuestion: SurveyQuestion) -> (UIView, [UIView]) {
        
        let stackerView = self.viewStackerWithRadioBtnsWithInput(surveyQuestion: surveyQuestion)
        
        let elements = stackerView.components.flatMap { view -> [UIView] in
            return (view as? OneRowStacker)?.components ?? [ ]
        }
        
        _ = elements.enumerated().map {
            if $0.offset == elements.count - 1 {
                $0.element.tag = $0.offset
            } else if let btnView = $0.element as? RadioBtnView  {
                btnView.radioBtn.tag = $0.offset
            }
        } // dodeli svakome unique TAG
        
        let finalView = questionViewWithHeadlineLabelFactory.questionViewWithHeadlineLabel(question: surveyQuestion.question, aboveStackerView: stackerView)
        
        return (finalView, elements)
        
    }
    
    private func viewStackerWithRadioBtnsWithInput(surveyQuestion: SurveyQuestion) -> ViewStacker {
        let question = surveyQuestion.question
        //let stacker = produceStackWithSameComponents(ofType: RadioBtnView.self, count: question.options.count, elementsInOneRow: 3)!
        let stacker = sameComponentsFactory.createStackWithSameComponents(ofType: RadioBtnView.self, componentsTotalCount: question.options.count, elementsInOneRow: 1)!
        
        guard let lastRow = stacker.components.last as? OneRowStacker,
            let lastElement = lastRow.components.last else {  return stacker }
        
        let txtBox = UITextField.init(frame: lastElement.bounds)
        txtBox.backgroundColor = .gray
        
        if lastRow.components.count == 3 { // max per row !
            guard let newRow = OneRowStacker.init(frame: lastRow.bounds, components: [txtBox]) else {return stacker}
            stacker.addAsLast(view: newRow)
        } else {
            lastRow.insertAsLast(view: txtBox) // dodaj ga na view
        }
        
        return stacker
        
    }
}
