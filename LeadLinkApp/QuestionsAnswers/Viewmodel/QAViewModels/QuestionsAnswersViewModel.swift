//
//  QuestionsAnswersViewModel.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 25/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift

class QuestionsAnswersViewModel: NSObject, QuestionsViewItemManaging {
    
    func getQuestionPageViewItems() -> [QuestionPageGetViewProtocol] {
        return items
    }
    
    func getAnswers() -> [MyAnswerProtocol] {
        let itemsWithAnswer: [QuestionPageViewModelProtocol] = self.items.filter {$0 is QuestionPageViewModelProtocol} as! [QuestionPageViewModelProtocol]
        let answers: [MyAnswerProtocol] = itemsWithAnswer.compactMap {$0.getActualAnswer()}
        return answers
    }
    
    private let campaign: Campaign? = {
        let campaignId = selectedCampaignId ?? 0 // hard-coded
        return factory.sharedCampaignsRepository.dataStore.readCampaign(id: campaignId).value
    }()
    
    private var questionInfos = [PresentQuestionInfoProtocol]()
    
    private var items = [QuestionPageGetViewProtocol]()
    private var viewmodels = [QuestionPageViewModelProtocol]()
    var childViewmodels = [Int: Questanable]()
    
    init(viewInfos: [ViewInfoProtocol]) {
        super.init()
        
        insertDistancerView(height: 12.0)
        
        _ = viewInfos.map({ viewInfo in
            if let info = viewInfo as? GroupViewInfoProtocol {
                let groupFactory = GroupViewFactory(text: info.getTitle())
                let groupItem = GroupViewItem(viewFactory: groupFactory)
                items.append(groupItem)
            } else if let info = viewInfo as? PresentQuestionInfoProtocol {
                self.questionInfos.append(info)
                appendQuestion(info: info)
            }
        })
        
        appendLocalItems()
        hookUpSaveEvent()
    }
    
    func appendQuestion(info: PresentQuestionInfoProtocol) {
        let question = info.getQuestion()
        if question.qType == .textField {
            if question.qOptions.first == "phone" {
                let labelPhoneItem = LabelPhoneTextField_ViewModelFactory(questionInfo: info).getViewModel()
                items.append(labelPhoneItem)
            } else {
                let labelTextItem = LabelTextViewViewModelFactory(questionInfo: info).getViewModel()
                items.append(labelTextItem)
            }
        }
        if question.qType == .textArea {
            let textAreaItem = TextAreaViewModelFactory(questionInfo: info).getViewModel()
            items.append(textAreaItem)
        }
        if question.qType == .dropdown {
            let dropdownItem = DropdownViewModelFactory(questionInfo: info).getViewModel()
            items.append(dropdownItem)
        }
        if question.qType == .checkbox {
            let checkboxBtnsItem = CheckboxBtnsViewModelFactory(questionInfo: info).getViewModel()
            items.append(checkboxBtnsItem)
        }
        if question.qType == .checkboxMultipleWithInput {
            let checkboxBtnsWithInputItem = CheckboxBtnsWithInputViewModelFactory(questionInfo: info).getViewModel()
            items.append(checkboxBtnsWithInputItem)
        }
        if question.qType == .radioBtn {
            let radioBtnsItem = RadioBtnsViewModelFactory(questionInfo: info).getViewModel()
            items.append(radioBtnsItem);
        }
        if question.qType == .radioBtnWithInput {
            let radioBtnsWithInputItem = RadioBtnsWithInput_ViewModelFactory(questionInfo: info).getViewModel()
            items.append(radioBtnsWithInputItem);
        }
        if question.qType == .termsSwitchBtn {
            let termsSwitchBtnItem = TermsSwitchBtnViewModelFactory(questionInfo: info).getViewModel()
            items.append(termsSwitchBtnItem);
        }
        
    }
    
    private func appendLocalItems() {
        appendOptInView()
        insertDistancerView(height: 24.0)
        appendSaveBtn()
        insertDistancerView(height: 24.0)
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
    
    private func insertDistancerView(height: CGFloat) {
        let distancerViewFactory = DistancerViewFactory(height: height)
        let lastDistancerItem = DistancerViewItem(viewFactory: distancerViewFactory)
        self.items.append(lastDistancerItem)
    }
    
    private func hookUpSaveEvent() {
        let saveBtnViewItem = self.items.last(where: {$0 is SaveBtnViewItem}) as! SaveBtnViewItem
        let btn = saveBtnViewItem.getView().subviews.first! as! UIButton
        btn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
    }
    
    @objc internal func btnTapped(_ sender: UIButton) { print("saveBtnTapped. save answers")
        
        let itemsWithAnswer: [QuestionPageViewModelProtocol] = self.items.filter {$0 is QuestionPageViewModelProtocol} as! [QuestionPageViewModelProtocol]
        let answers: [[String]] = itemsWithAnswer.compactMap {$0.getActualAnswer()}.map {$0.content}
//        print("save answers:")
//        print(answers)
    }
    
}

protocol Questanable {
    var question: QuestionProtocol {get set}
    var code: String {get set}
}

protocol Answerable {
    var answer: MyAnswerProtocol? {get set}
}

extension QuestionsAnswersViewModel: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        let questionInfo = questionInfos.first(where: {$0.getQuestion().qId == textView.tag})
        let placeholderTxt = questionInfo?.getQuestion().qDesc
        if textView.text == placeholderTxt {
            textView.text = ""
            textView.textColor = .black
        }
    }
}
