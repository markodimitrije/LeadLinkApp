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
    
    // TODO: ovaj objekat treba da ima parentWorker sa childworkers od kojih
    // 1. loadItems - -  - - - - - OK
    // 2. fetchDelegate from web
    // 3. save to realm
    // 4. itd...
    
    func getQuestionPageViewItems() -> [QuestionPageGetViewProtocol] {
        return items
    }
    
    func getAnswers() -> [MyAnswerProtocol] {
        let itemsWithAnswer: [QuestionPageViewModelProtocol] = self.items.filter {$0 is QuestionPageViewModelProtocol} as! [QuestionPageViewModelProtocol]
        let answers: [MyAnswerProtocol] = itemsWithAnswer.compactMap {$0.getActualAnswer()}
        return answers
    }
    
    private var questionInfos = [SurveyQuestionProtocol]()
    
    private var items = [QuestionPageGetViewProtocol]()
    
    init(getViewItemsWorker: QuestionPageGetViewItemsProtocol ) {
        super.init()
        self.items = getViewItemsWorker.getViewItems()
        hookUpSaveEvent()
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
