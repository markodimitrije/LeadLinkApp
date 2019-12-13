//
//  RadioBtnsViewModel.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 11/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class RadioBtnsViewModel: NSObject, QuestionPageViewModelProtocol, BtnTapListening {
    
    @objc func btnTapped(_ sender: UIButton) {
        setSelectedRadioBtnAndClearOthers(sender: sender)
    }
    
    private var question: PresentQuestion
    private var answer: MyAnswer?
    private var code: String = ""
    
    private var view: UIView!
    private var singleRadioBtnViewModels = [SingleRadioBtnViewModel]()
    
    init(questionInfo: PresentQuestionInfoProtocol, radioBtnsFactory: RadioBtns_ViewFactory) {
        self.question = questionInfo.getQuestion()
        self.answer = questionInfo.getAnswer()
        self.code = questionInfo.getCode()
        super.init()
        self.singleRadioBtnViewModels = radioBtnsFactory.getViewModels()
        self.view = radioBtnsFactory.getView()
        self.view.tag = questionInfo.getQuestion().id
        
        _ = self.view.findViews(subclassOf: UIButton.self).map {
            $0.addTarget(self, action: #selector(RadioBtnsViewModel.btnTapped), for: .touchUpInside)
        }
    }
    
    func getView() -> UIView {
        return self.view
    }
    
    func getActualAnswer() -> MyAnswer? { // single selection - not tested !!

        let questionOptions = question.options

        let selectedViewModels = singleRadioBtnViewModels.filter {$0.isOn}
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
    
    private func setSelectedRadioBtnAndClearOthers(sender: UIButton) {
        //        print("RadioBtnsViewModel.btnTapped - IMPLEMENT ME, sender.tag = \(sender.tag)")
        singleRadioBtnViewModels[sender.tag].isOn = !singleRadioBtnViewModels[sender.tag].isOn
        print("sve ostale setuj na false")
        let toDisable = singleRadioBtnViewModels.filter {$0.getView().tag != sender.tag}
        _ = toDisable.map {$0.isOn = false}
    }
}

