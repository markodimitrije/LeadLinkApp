//
//  ParentViewModel.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 25/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift

class ParentViewModel: NSObject, QuestionsViewItemManaging {
    
    func getQuestionPageViewItems() -> [QuestionPageGetViewProtocol] {
        return items
    }
    
    func getAnswers() -> [MyAnswer] {
        let itemsWithAnswer: [QuestionPageViewModelProtocol] = self.items.filter {$0 is QuestionPageViewModelProtocol} as! [QuestionPageViewModelProtocol]
        let answers: [MyAnswer] = itemsWithAnswer.compactMap {$0.getActualAnswer()}
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
        //setYourselfAsDelegateToAllTextViews()
    }
    
    
    
    func appendQuestion(info: PresentQuestionInfoProtocol) {
        
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
            items.append(radioBtnsItem);
        }
        if info.getQuestion().type == .radioBtnWithInput {
            let radioBtnsWithInputItem = RadioBtnsWithInput_ViewModelFactory(questionInfo: info).getViewModel()
            items.append(radioBtnsWithInputItem);
        }
        if info.getQuestion().type == .termsSwitchBtn {
            let termsSwitchBtnItem = TermsSwitchBtnViewModelFactory(questionInfo: info).getViewModel()
            items.append(termsSwitchBtnItem);
        }
        
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
    
    private func setYourselfAsDelegateToAllTextViews() {
        _ = self.items.map { (item) in
            let textViews = item.getView().findViews(subclassOf: UITextView.self)
            _ = textViews.map({$0.delegate = self})
        }
    }
    
    @objc internal func btnTapped(_ sender: UIButton) { print("saveBtnTapped. save answers")
        
        let itemsWithAnswer: [QuestionPageViewModelProtocol] = self.items.filter {$0 is QuestionPageViewModelProtocol} as! [QuestionPageViewModelProtocol]
        let answers: [[String]] = itemsWithAnswer.compactMap {$0.getActualAnswer()}.map {$0.content}
        print("save answers:")
        print(answers)
    }
    
    init(viewmodels: [Questanable]) {
        super.init()
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

extension ParentViewModel: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        let questionInfo = questionInfos.first(where: {$0.getQuestion().id == textView.tag})
        let placeholderTxt = questionInfo?.getQuestion().description ?? ""
        if textView.text == placeholderTxt {
            textView.text = ""
            textView.textColor = .black
        }
    }
}
