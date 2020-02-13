//
//  QuestionPageGetViewItemsWorker.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 01/01/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import UIKit

protocol QuestionPageGetViewItemsProtocol {
    func getViewItems() -> [QuestionPageGetViewProtocol]
}

class QuestionPageGetViewItemsWorker: QuestionPageGetViewItemsProtocol {
    
    private var items = [QuestionPageGetViewProtocol]()
    private var questionInfos = [SurveyQuestionProtocol]()
    private let campaign: CampaignProtocol
    
    func getViewItems() -> [QuestionPageGetViewProtocol] {
        return self.items
    }
    
    init(viewInfos: [ViewInfoProtocol], campaign: CampaignProtocol) {
        
        self.campaign = campaign
        
        loadItems(viewInfos: viewInfos)
    }
    
    private func loadItems(viewInfos: [ViewInfoProtocol]) {
        
        insertDistancerView(height: 12.0)
        
        _ = viewInfos.map({ viewInfo in
            if let info = viewInfo as? GroupViewInfoProtocol {
                let groupFactory = GroupViewFactory(text: info.getTitle())
                let groupItem = GroupViewItem(viewFactory: groupFactory)
                items.append(groupItem)
            } else if let surveyQuestion = viewInfo as? SurveyQuestionProtocol {
                self.questionInfos.append(surveyQuestion)
                appendQuestion(surveyQuestion: surveyQuestion)
            }
        })
        
        appendLocalItems()
        
        insertGroupSeparators()
    }
    
    func appendQuestion(surveyQuestion: SurveyQuestionProtocol) {
        let question = surveyQuestion.getQuestion()
        if question.qType == .textField {
            if question.qOptions.first == "phone" {
                let labelPhoneItem = LabelPhoneTextField_ViewModelFactory(surveyQuestion: surveyQuestion).getViewModel()
                items.append(labelPhoneItem)
            } else {
                let labelTextItem = LabelTextViewViewModelFactory(surveyQuestion: surveyQuestion).getViewModel()
                items.append(labelTextItem)
            }
        }
        if question.qType == .textArea {
            let textAreaItem = TextAreaViewModelFactory(surveyQuestion: surveyQuestion).getViewModel()
            items.append(textAreaItem)
        }
        if question.qType == .dropdown {
            let dropdownItem = DropdownViewModelFactory(surveyQuestion: surveyQuestion).getViewModel()
            items.append(dropdownItem)
        }
        if question.qType == .checkbox {
            let checkboxBtnsItem = CheckboxBtnsViewModelFactory(surveyQuestion: surveyQuestion).getViewModel()
            items.append(checkboxBtnsItem)
        }
        if question.qType == .checkboxMultipleWithInput {
            let checkboxBtnsWithInputItem = CheckboxBtnsWithInputViewModelFactory(surveyQuestion: surveyQuestion).getViewModel()
            items.append(checkboxBtnsWithInputItem)
        }
        if question.qType == .radioBtn {
            let radioBtnsItem = RadioBtnsViewModelFactory(surveyQuestion: surveyQuestion).getViewModel()
            items.append(radioBtnsItem);
        }
        if question.qType == .radioBtnWithInput {
            let radioBtnsWithInputItem = RadioBtnsWithInput_ViewModelFactory(surveyQuestion: surveyQuestion).getViewModel()
            items.append(radioBtnsWithInputItem);
        }
        if question.qType == .termsSwitchBtn {
            let termsSwitchBtnItem = TermsSwitchBtnViewModelFactory(surveyQuestion: surveyQuestion).getViewModel()
            items.append(termsSwitchBtnItem);
        }
        
    }
    
    private func appendLocalItems() {
        
        appendOptInView()
        insertDistancerView(height: 24.0)
        appendSaveBtn()
        insertDistancerView(height: 24.0)
    }
    
    private func insertGroupSeparators() {
        
        var modifiedItems = [QuestionPageGetViewProtocol]()
        
        _ = self.items.enumerated().map { (index, viewItem) in
            if (viewItem is GroupViewItem) && index != 1 { // ne zelimo na vrhu tabele, nije 0 zbog distancerView (12pt)
                let groupSeparatorItem = getGroupSeparatorViewItem()
                modifiedItems.append(groupSeparatorItem)
            }
            modifiedItems.append(viewItem)
        }

        self.items = modifiedItems
    }
    
    private func appendOptInView() {
        guard let optIn = campaign.settings?.optIn else {return}
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
    
    private func getGroupSeparatorViewItem() -> GroupSeparatorViewItem {
        let groupSeparatorViewFactory = GroupSeparatorViewFactory()
        return GroupSeparatorViewItem(viewFactory: groupSeparatorViewFactory)
    }
    
}
