//
//  CheckboxBtnsViewModel.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class CheckboxBtnsViewModel: NSObject, QuestionPageViewModelProtocol, BtnTapListening {
    
    @objc func btnTapped(_ sender: UIButton) {
        singleCheckboxBtnViewModel[sender.tag].isOn = !singleCheckboxBtnViewModel[sender.tag].isOn
    }
    
    private var question: QuestionProtocol
    private var answer: MyAnswerProtocol?
    private var code: String = ""
    
    private var view: UIView!
    private var singleCheckboxBtnViewModel = [SingleCheckboxBtnViewModel]()
    
    init(surveyQuestion: SurveyQuestionProtocol, labelFactory: LabelFactory, checkboxBtnsFactory: CheckboxBtnsFactory) {
        self.question = surveyQuestion.getQuestion()
        self.answer = surveyQuestion.getAnswer()
        self.code = surveyQuestion.getCode()
        super.init()
        self.singleCheckboxBtnViewModel = checkboxBtnsFactory.getViewModels()
        
        let viewStacker = CodeVerticalStacker(views: [labelFactory.getView(), checkboxBtnsFactory.getView()])
        self.view = viewStacker.getView()
        self.view.tag = surveyQuestion.getQuestion().qId
        
        _ = self.view.findViews(subclassOf: UIButton.self).map {
            $0.addTarget(self, action: #selector(CheckboxBtnsViewModel.btnTapped), for: .touchUpInside)
        }
    }
    
    func getView() -> UIView {
        return self.view
    }
    
    func getActualAnswer() -> MyAnswerProtocol? { // multiple selection
        
        let questionOptions = question.qOptions
        
        let selectedViewModels = singleCheckboxBtnViewModel.filter {$0.isOn}
        let selectedTags = selectedViewModels.map {$0.getView().tag}
        let content = selectedTags.map {questionOptions[$0]}
            
        if answer != nil {
            answer!.content = content
            answer!.optionIds = selectedTags
            
        } else {
            answer = MyAnswer(question: question, code: code, content: content, optionIds: selectedTags)
        }
        return answer
    }
}

