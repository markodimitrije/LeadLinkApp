//
//  ParentViewModel.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 25/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift

class ParentViewModel: QuestionsViewItemManaging {
    
    func getQuestionPageViewItems() -> [QuestionPageGetViewProtocol] {
        return items
    }
    
    private let campaign: Campaign? = {
        let campaignId = selectedCampaignId ?? 0 // hard-coded
        return factory.sharedCampaignsRepository.dataStore.readCampaign(id: campaignId).value
    }()
    
    private var questionInfos = [PresentQuestionInfoProtocol]()
    private var items = [QuestionPageGetViewProtocol]()
    var childViewmodels = [Int: Questanable]()
    
    init(questionInfos: [PresentQuestionInfoProtocol]) {
        self.questionInfos = questionInfos
        _ = questionInfos.map { info in
            if info.getQuestion().type == .textField {
                let labelTextItem = LabelTextFieldViewModelFactory(questionInfo: info).getViewModel()
                items.append(labelTextItem)
            }
            if info.getQuestion().type == .textArea {
                let textAreaItem = TextAreaViewModelFactory(questionInfo: info).getViewModel()
                items.append(textAreaItem)
            }
            if info.getQuestion().type == .dropdown {
                let dropdownItem = DropdownViewModelFactory(questionInfo: info).getViewModel()
                items.append(dropdownItem)
            }
            if info.getQuestion().type == .checkbox {
                let checkboxBtnsItem = CheckboxBtnsViewModelFactory(questionInfo: info).getViewModel()
                items.append(checkboxBtnsItem)
            }
            if info.getQuestion().type == .checkboxMultipleWithInput {
                let checkboxBtnsWithInputItem = CheckboxBtnsWithInputViewModelFactory(questionInfo: info).getViewModel()
                items.append(checkboxBtnsWithInputItem)
            }
            if info.getQuestion().type == .radioBtn {
                let radioBtnsItem = RadioBtnsViewModelFactory(questionInfo: info).getViewModel()
                items.append(radioBtnsItem)
            }
            if info.getQuestion().type == .radioBtnWithInput {
                let radioBtnsWithInputItem = RadioBtnsWithInput_ViewModelFactory(questionInfo: info).getViewModel()
                items.append(radioBtnsWithInputItem)
            }
            if info.getQuestion().type == .termsSwitchBtn {
                let termsSwitchBtnItem = TermsSwitchBtnViewModelFactory(questionInfo: info).getViewModel()
                items.append(termsSwitchBtnItem)
            }
        }
        appendLocalItems()
        hookUpSaveEvent()
    }
    
    private func appendLocalItems() {
        appendOptInView()
        appendSaveBtn()
    }
    
    private func appendOptInView() {
        guard let optIn = campaign?.settings?.optIn else {return}
        let hiperlinkFactory = TextWithHiperlinkViewFactory(text: optIn.text, hiperlinkText: optIn.privacyPolicy, urlString: optIn.url)
        let optInFactory = OptInViewFactory(optIn: optIn, titleWithHiperlinkViewFactory: hiperlinkFactory)
        let optInItem = OptInViewItem(optInViewFactory: optInFactory)
        self.items.append(optInItem)
    }
    
    private func appendSaveBtn() {
        let saveBtnFactory = SaveButtonFactory(title: "Save", width: allowedQuestionsWidth)
        let saveBtnItem = SaveBtnViewItem(saveBtnFactory: saveBtnFactory)
        self.items.append(saveBtnItem)
    }
    
    private func hookUpSaveEvent() {
        let saveBtnViewItem = self.items.last(where: {$0 is SaveBtnViewItem}) as! SaveBtnViewItem
        let btn = saveBtnViewItem.getView().subviews.first! as! UIButton
        btn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
    }
    
    @objc internal func btnTapped(_ sender: UIButton) { print("saveBtnTapped. save answers")
        
        let itemsWithAnswer: [QuestionPageViewModelProtocol] = self.items.filter {$0 is QuestionPageViewModelProtocol} as! [QuestionPageViewModelProtocol]
        let answers: [[String]] = itemsWithAnswer.compactMap {$0.getActualAnswer()}.map {$0.content}
        print("save answers:")
        print(answers)
    }
    
    init(viewmodels: [Questanable]) {
        
        _ = viewmodels.map { viewmodel -> Void in
            
            childViewmodels[viewmodel.question.id] = viewmodel
        }
    }
}

protocol Questanable {
    var question: PresentQuestion {get set}
    var code: String {get set}
}

protocol Answerable {
    var answer: MyAnswer? {get set}
}

class QuestionInfoFactory {
    func convert(surveyQuestion: SurveyQuestion) -> PresentQuestionInfoProtocol {
        let question = surveyQuestion.question
        let answer = surveyQuestion.answer
        let code = "3" // hard-coded
        return PresentQuestionInfo(question: question, answer: answer, code: code)
    }
}
