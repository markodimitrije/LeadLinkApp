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
    
    private let bag = DisposeBag()
    lazy private var answersUpdater: AnswersUpdating = AnswersUpdater.init(surveyInfo: questionsVC.surveyInfo,
                                                                              questionsAnswersViewModel: self)
    private let answersWebReporter = AnswersReportsToWebState.init()
    private var questionsVC: QuestionsAnswersVC {
        (UIApplication.topViewController() as! QuestionsAnswersVC)
    }
    
    var formIsValid = PublishSubject<QuestionProtocol?>()
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
        reactOnSaveEvent()
    }
    
    private func reactOnSaveEvent() {
        
        let myAnswers = self.answersUpdater.updateAnswers() // both actual + realm
        self.persistAnswersIfFormIsValid(answers: myAnswers)
    }
    
    private func persistAnswersIfFormIsValid(answers: [MyAnswerProtocol]) {
                
        let validator = QA_Validation(surveyInfo: questionsVC.surveyInfo,
                                      questions: questionsVC.questions,
                                      answers: answers)
        
        if validator.questionsFormIsValid {
            
            //strongSelf.navigationController?.popViewController(animated: true)
            
            let survey = (UIApplication.topViewController() as? QuestionsAnswersVC)?.surveyInfo
            
            saveAnswersToRealmAndUpdateSurveyInfo(surveyInfo: survey!, answers: answers)
            
            formIsValid.onNext(nil)
            
            let newReport = AnswersReport.init(surveyInfo: survey!, answers: answers, success: false)
            self.answersWebReporter.report.accept(newReport)
            
        } else {
//            strongSelf.showAlertFormNotValid(forQuestion: validator.invalidFieldQuestion)
            formIsValid.onNext(validator.invalidFieldQuestion)
        }
    }
    
    private func saveAnswersToRealmAndUpdateSurveyInfo(surveyInfo: SurveyInfo, answers: [MyAnswerProtocol]) {
        surveyInfo.save(answers: answers)
            .subscribe({ (saved) in
                print("answers saved to realm = \(saved)")
                //self.surveyInfo = surveyInfo
                (UIApplication.topViewController() as? QuestionsAnswersVC)?.surveyInfo = surveyInfo
            })
            .disposed(by: bag)
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
