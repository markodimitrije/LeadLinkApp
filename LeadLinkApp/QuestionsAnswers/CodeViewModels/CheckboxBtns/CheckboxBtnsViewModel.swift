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
    
    private var question: PresentQuestion
    private var answer: MyAnswer?
    private var code: String = ""
    
    private var view: UIView!
    private var singleCheckboxBtnViewModel = [SingleCheckboxBtnViewModel]()
    
    init(questionInfo: PresentQuestionInfoProtocol, labelFactory: LabelFactory, checkboxBtnsFactory: CheckboxBtnsFactory) {
        self.question = questionInfo.getQuestion()
        self.answer = questionInfo.getAnswer()
        self.code = questionInfo.getCode()
        super.init()
        self.singleCheckboxBtnViewModel = checkboxBtnsFactory.getViewModels()
        
        let viewStacker = CodeVerticalStacker(views: [labelFactory.getView(), checkboxBtnsFactory.getView()])
        self.view = viewStacker.getView()
        
        _ = self.view.findViews(subclassOf: UIButton.self).map {
            $0.addTarget(self, action: #selector(CheckboxBtnsViewModel.btnTapped), for: .touchUpInside)
        }
    }
    
    init(question: PresentQuestion, answer: MyAnswer?, code: String) {
        self.question = question
        self.answer = answer
        self.code = code
        super.init()
        loadView()
    }
    
    private func loadView() {
        let titles = question.options
        
        let selected = titles.map {(answer?.content ?? [ ]).contains($0)}
        
        let singleCheckboxBtnViewModel = titles.enumerated().map { (index, title) -> SingleCheckboxBtnViewModel in
            let checkboxBtnFactory = SingleCheckboxBtnViewFactory(tag: index,
                                                               isOn: selected[index],
                                                               titleText: title)
            let checkboxBtnViewModel = SingleCheckboxBtnViewModel(viewFactory: checkboxBtnFactory, isOn: selected[index])
            return checkboxBtnViewModel
        }
        self.singleCheckboxBtnViewModel = singleCheckboxBtnViewModel
        let singleViews = singleCheckboxBtnViewModel.map {$0.getView()}
        let verticalStackerFactory = CodeVerticalStacker(views: singleViews)
        self.view = verticalStackerFactory.getView()
    }
    
    func getView() -> UIView {
        return self.view
    }
    
    func getActualAnswer() -> MyAnswer? { // multiple selection
        
        let questionOptions = question.options
        
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

