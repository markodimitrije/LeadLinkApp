//  QuestionsAnswersViewModel.swift
//  // TODO: ovaj objekat treba da ima parentWorker sa childworkers od kojih
//  1. loadItems - -  - - - - - OK
//  2. delegate ce ti dodati preth. screen ---- OK
//  3. save to realm ------ OK

//  4. PrepopulateDelegateDataDecisioner, DelegateEmailScrambler inject spolja u vm-voj Factory
//  5. Observable viewItems analogno sa formIsValid i onda obe embed u OUTPUT

//  Created by Marko Dimitrijevic on 25/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.

import Foundation
import RxSwift

class QuestionsAnswersViewModel: NSObject, QuestionsViewItemManaging {
    
    private let bag = DisposeBag()
    
    private let surveyInfo: SurveyInfo
    private var getViewItemsWorkerFactory: QuestionPageGetViewItemsWorkerFactoryProtocol
    private var reportAnswersToWebWorker: ReportAnswersToWebWorkerProtocol
    private var obsDelegate: Observable<Delegate?>
    private let prepopulateDecisioner: PrepopulateDelegateDataDecisionerProtocol
    private let delegateEmailScrambler: DelegateEmailScrambling
    private let validator: QA_ValidationProtocol
    
    private var questionsVC: QuestionsAnswersVC? {
        (UIApplication.topViewController() as? QuestionsAnswersVC)
    }
    
    private var questionInfos = [SurveyQuestionProtocol]()
    private var items = [QuestionPageGetViewProtocol]()
    
    var formIsValid = PublishSubject<QuestionProtocol?>()
    
    func getQuestionPageViewItems() -> [QuestionPageGetViewProtocol] {
        return items
    }
    
    func getAnswers() -> [MyAnswerProtocol] {
        let itemsWithAnswer: [QuestionPageViewModelProtocol] = self.items.filter {$0 is QuestionPageViewModelProtocol} as! [QuestionPageViewModelProtocol]
        let answers: [MyAnswerProtocol] = itemsWithAnswer.compactMap {$0.getActualAnswer()}
        return answers
    }
    
    init(surveyInfo: SurveyInfo,
         getViewItemsWorkerFactory: QuestionPageGetViewItemsWorkerFactoryProtocol,
         reportAnswersToWebWorker: ReportAnswersToWebWorkerProtocol,
         obsDelegate: Observable<Delegate?>,
         prepopulateDelegateDataDecisioner: PrepopulateDelegateDataDecisionerProtocol,
         delegateEmailScrambler: DelegateEmailScrambling,
         validator: QA_ValidationProtocol) {
        
        self.surveyInfo = surveyInfo
        self.getViewItemsWorkerFactory = getViewItemsWorkerFactory
        self.reportAnswersToWebWorker = reportAnswersToWebWorker
        self.obsDelegate = obsDelegate
        self.prepopulateDecisioner = prepopulateDelegateDataDecisioner
        self.delegateEmailScrambler = delegateEmailScrambler
        self.validator = validator
        
        super.init()
        listenOnDelegate()
    }
    
    private func listenOnDelegate() {
        obsDelegate.take(1)
            .subscribe(onNext: { (delegate) in
                self.dataReceived(delegate: delegate)
            })
            .disposed(by: bag)
    }
    
    private func dataReceived(delegate: Delegate?) {
        
        guard let delegate = delegate else {
            self.shouldRedrawScreen(surveyInfo: self.surveyInfo)
            return
        }
        
        guard prepopulateDecisioner.shouldPrepopulateDelegateData() else {
            self.shouldRedrawScreen(surveyInfo: self.surveyInfo)
            return
        }
        
        var myDelegate = delegate
        
        if !delegateEmailScrambler.shouldShowEmail() {
            myDelegate.email = ""
        }
        
        let updatedSurvey = self.surveyInfo.updated(withDelegate: myDelegate)
        
        self.shouldRedrawScreen(surveyInfo: updatedSurvey)
        
    }
    
    private func shouldRedrawScreen(surveyInfo: SurveyInfo) {
        
        let getItemsWorker = getViewItemsWorkerFactory.make(surveyInfo: surveyInfo)
        items = getItemsWorker.getViewItems()
        hookUpSaveEvent()
        questionsVC?.redrawScreen()
    }
    
    private func hookUpSaveEvent() {
        let saveBtnViewItem = self.items.last(where: {$0 is SaveBtnViewItem}) as! SaveBtnViewItem
        let btn = saveBtnViewItem.getView().subviews.first! as! UIButton
        btn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
    }
    
    @objc internal func btnTapped(_ sender: UIButton) { print("saveBtnTapped. save answers")
        reactOnSaveEvent()
    }
    
    private func reactOnSaveEvent() {
        
        let myAnswers = self.getAnswers()
        self.persistAnswersIfFormIsValid(answers: myAnswers)
    }
    
    private func persistAnswersIfFormIsValid(answers: [MyAnswerProtocol]) {
                
        if validator.isQuestionsFormValid(answers: answers) {

            saveAnswersToRealmAndUpdateSurveyInfo(surveyInfo: self.surveyInfo, answers: answers)
            
            formIsValid.onNext(nil)
            
            reportAnswersToWeb(surveyInfo: self.surveyInfo, answers: answers)
            
        } else {
            formIsValid.onNext(validator.invalidFieldQuestion)
        }
    }
    
    private func saveAnswersToRealmAndUpdateSurveyInfo(surveyInfo: SurveyInfo, answers: [MyAnswerProtocol]) {
        surveyInfo.save(answers: answers) // save to realm
            .subscribe({ (saved) in
                self.questionsVC?.redrawScreen()
            })
            .disposed(by: bag)
    }
    
    private func reportAnswersToWeb(surveyInfo: SurveyInfo, answers: [MyAnswerProtocol]) {
        var survey = surveyInfo
        survey.answers = answers
        let newReport = AnswersReport.init(surveyInfo: survey, success: false)
        self.reportAnswersToWebWorker.report.accept(newReport)
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
