//
//  QuestionsAnswersViewModel.swift
//  // TODO: ovaj objekat treba da ima parentWorker sa childworkers od kojih
//  1. loadItems - -  - - - - - OK
//  2. fetchDelegate from web - - -- - - OK (transfer to dedicated worker)
//  3. save to realm
//  4. itd...
//
//  Created by Marko Dimitrijevic on 25/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift

class QuestionsAnswersViewModel: NSObject, QuestionsViewItemManaging {
    
    private let bag = DisposeBag()
    lazy private var answersUpdater: AnswersUpdating = AnswersUpdater.init(surveyInfo: self.surveyInfo, questionsAnswersViewModel: self)
    
    private var getViewItemsWorker: QuestionPageGetViewItemsProtocol
    private var reportAnswersToWebWorker: ReportAnswersToWebWorkerProtocol
    private var obsDelegate: Observable<Delegate?>
    
    private var questionsVC: QuestionsAnswersVC? {
        (UIApplication.topViewController() as? QuestionsAnswersVC)
    }
    
    var formIsValid = PublishSubject<QuestionProtocol?>()
    
    func getQuestionPageViewItems() -> [QuestionPageGetViewProtocol] {
        return items
    }
    
    func getAnswers() -> [MyAnswerProtocol] {
        let itemsWithAnswer: [QuestionPageViewModelProtocol] = self.items.filter {$0 is QuestionPageViewModelProtocol} as! [QuestionPageViewModelProtocol]
        let answers: [MyAnswerProtocol] = itemsWithAnswer.compactMap {$0.getActualAnswer()}
        return answers
    }
    
    private var questionInfos = [SurveyQuestionProtocol]()
    
    let surveyInfo: SurveyInfo
    private var items = [QuestionPageGetViewProtocol]()
    
    init(surveyInfo: SurveyInfo,
         getViewItemsWorker: QuestionPageGetViewItemsProtocol,
         reportAnswersToWebWorker: ReportAnswersToWebWorkerProtocol,
         obsDelegate: Observable<Delegate?>) {
       
        print("QuestionsAnswersViewModel is getting initialized!!")
        
        self.surveyInfo = surveyInfo
        self.getViewItemsWorker = getViewItemsWorker
        self.reportAnswersToWebWorker = reportAnswersToWebWorker
        self.obsDelegate = obsDelegate
        
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
        
        let decisioner = PrepopulateDelegateDataDecisioner.init(surveyInfo: self.surveyInfo,
                                                                codeToCheck: self.surveyInfo.code)
        guard decisioner.shouldPrepopulateDelegateData() else {
            self.shouldRedrawScreen(surveyInfo: self.surveyInfo)
            return
        }
        
        var myDelegate = delegate
        
        let delegateEmailScrambler = DelegateEmailScrambler(campaign: self.surveyInfo.campaign)
        if !delegateEmailScrambler.shouldShowEmail() {
            myDelegate.email = ""
        }
        
        let updatedSurvey = self.surveyInfo.updated(withDelegate: myDelegate)
        
        self.shouldRedrawScreen(surveyInfo: updatedSurvey)
        
    }
    
    private func shouldRedrawScreen(surveyInfo: SurveyInfo) {
        print("should redraw screen is called")
        let surveyQuestions = SurveyQuestionsLoader(surveyInfo: surveyInfo).getSurveyQuestions()
        let viewInfoProvider = ViewInfoProvider(questions: surveyQuestions,
                                                code: surveyInfo.code)
        let getItemsWorker = QuestionPageGetViewItemsWorker(viewInfos: viewInfoProvider.getViewInfos(),
                                                            campaign: surveyInfo.campaign)
        items = getItemsWorker.getViewItems()
        hookUpSaveEvent()
        questionsVC?.configureQuestionForm()
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
        
        let myAnswers = self.answersUpdater.updateAnswers() // both actual + realm
        self.persistAnswersIfFormIsValid(answers: myAnswers)
    }
    
    private func persistAnswersIfFormIsValid(answers: [MyAnswerProtocol]) {
                
        let validator = QA_Validation(surveyInfo: self.surveyInfo,
                                      questions: self.surveyInfo.questions,
                                      answers: answers)
        
        if validator.questionsFormIsValid {
            
            let survey = self.surveyInfo

            saveAnswersToRealmAndUpdateSurveyInfo(surveyInfo: survey, answers: answers)
            
            formIsValid.onNext(nil)
            
            reportAnswersToWeb(surveyInfo: survey, answers: answers)
            
        } else {
            print("ili ovaj ?!?")
            formIsValid.onNext(validator.invalidFieldQuestion)
        }
    }
    
    private func saveAnswersToRealmAndUpdateSurveyInfo(surveyInfo: SurveyInfo, answers: [MyAnswerProtocol]) {
        surveyInfo.save(answers: answers) // save to realm
            .subscribe({ (saved) in
                self.questionsVC?.configureQuestionForm()
            })
            .disposed(by: bag)
    }
    
    private func reportAnswersToWeb(surveyInfo: SurveyInfo, answers: [MyAnswerProtocol]) {
        var survey = surveyInfo
        survey.answers = answers
        let newReport = AnswersReport.init(surveyInfo: survey, success: false)
        self.reportAnswersToWebWorker.report.accept(newReport)
    }
    
    deinit {
        let notificationName = Notification.Name.init("questionAnswersVCdidLoad")
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
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
