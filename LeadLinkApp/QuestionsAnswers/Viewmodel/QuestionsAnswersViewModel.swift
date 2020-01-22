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
    lazy private var answersUpdater: AnswersUpdating = AnswersUpdater.init(surveyInfo: questionsVC.surveyInfo, questionsAnswersViewModel: self)
    private var answersWebReporter: AnswersReportsToWebStateProtocol
    
    private var questionsVC: QuestionsAnswersVC {
        (UIApplication.topViewController() as! QuestionsAnswersVC)
    }
    
    var formIsValid = PublishSubject<QuestionProtocol?>()
    // TODO: ovaj objekat treba da ima parentWorker sa childworkers od kojih
    // 1. loadItems - -  - - - - - OK
    // 2. fetchDelegate from web - - -- - - OK (transfer to dedicated worker)
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
    
    init(getViewItemsWorker: QuestionPageGetViewItemsProtocol,
         answersWebReporterWorker: AnswersReportsToWebStateProtocol) {
        self.items = getViewItemsWorker.getViewItems()
        self.answersWebReporter = answersWebReporterWorker
        super.init()
        hookUpSaveEvent()
    }
    
    private func hookUpSaveEvent() {
        let saveBtnViewItem = self.items.last(where: {$0 is SaveBtnViewItem}) as! SaveBtnViewItem
        let btn = saveBtnViewItem.getView().subviews.first! as! UIButton
        btn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
    }
    
    @objc internal func btnTapped(_ sender: UIButton) { print("saveBtnTapped. save answers")
        reactOnSaveEvent()
    }
    
    func fetchDelegateAndSaveToRealm(code: String) {
        
        guard let surveyInfo = questionsVC.surveyInfo else {return}
        
        let decisioner = PrepopulateDelegateDataDecisioner.init(surveyInfo: surveyInfo,
                                                                codeToCheck: code)
        guard decisioner.shouldPrepopulateDelegateData() else {
            return
        }

        let oNewDelegate = DelegatesRemoteAPI.shared.getDelegate(withCode: code)
        
        oNewDelegate
            .subscribe(onNext: { [weak self] delegate in
                guard let sSelf = self, let delegate = delegate else { return }
                
                var myDelegate = delegate
                
                let delegateEmailScrambler = DelegateEmailScrambler(campaign: surveyInfo.campaign)
                if !delegateEmailScrambler.shouldShowEmail() {
                    myDelegate.email = ""
                }
                
                let updatedSurvey = surveyInfo.updated(withDelegate: myDelegate)
                
                DispatchQueue.main.async {
                    sSelf.saveAnswersToRealmAndUpdateSurveyInfo(surveyInfo: updatedSurvey,
                                                                answers: updatedSurvey.answers) //redundant....
                }
            })
            .disposed(by: bag)
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
            
            let survey = questionsVC.surveyInfo
            
            saveAnswersToRealmAndUpdateSurveyInfo(surveyInfo: survey!, answers: answers)
            
            formIsValid.onNext(nil)
            
            let newReport = AnswersReport.init(surveyInfo: survey!, answers: answers, success: false)
            self.answersWebReporter.report.accept(newReport)
            
        } else {
            formIsValid.onNext(validator.invalidFieldQuestion)
        }
    }
    
    private func saveAnswersToRealmAndUpdateSurveyInfo(surveyInfo: SurveyInfo, answers: [MyAnswerProtocol]) {
        surveyInfo.save(answers: answers) // save to realm
            .subscribe({ (saved) in
                self.questionsVC.surveyInfo = surveyInfo //update state
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
