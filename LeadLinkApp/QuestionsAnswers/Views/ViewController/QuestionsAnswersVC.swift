//
//  QuestionsAnswersVC.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 13/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RxSwift
import RxCocoa

class QuestionsAnswersVC: UIViewController, UIPopoverPresentationControllerDelegate, Storyboarded {
        
    @IBOutlet weak var scrollView: QuestionsScrollView!
    @IBOutlet weak var stackView: UIStackView!
    
    private var questionInfos = [PresentQuestionInfoProtocol]()
    private var questions: [QuestionProtocol] {
        return questionInfos.map {$0.getQuestion()}
    }
    private var viewModel: QuestionsAnswersViewModel!
    private var viewItems = [QuestionPageGetViewProtocol]()
    
    lazy private var keyboardHandler: KeyboardHandling = {
        return ScrollViewKeyboardHandler(scrollView: scrollView)
    }()
    
    var bag = DisposeBag()
    
    private let answersWebReporter = AnswersReportsToWebState.init() // report to web (manage API and REALM if failed)
    
    lazy private var answersUpdater: AnswersUpdating = AnswersUpdater.init(surveyInfo: surveyInfo,
                                                                           questionsAnswersViewModel: viewModel)
    // API
    var surveyInfo: SurveyInfo! {
        didSet {
            self.fetchDelegateAndSaveToRealm(code: self.surveyInfo.code)
            if oldValue != nil {
                stackView.removeAllSubviews()
                questionInfos = SurveyQuestionsLoader(surveyInfo: surveyInfo).getQuestionInfos()
                loadParentViewModel(questions: questionInfos)
                subscribeListeningToSaveEvent()
            }
        }
    }
    
    override func viewDidLoad() { super.viewDidLoad()
        self.scrollView.delegate = self
        keyboardHandler.registerForKeyboardEvents()
        configureQuestionForm()
    }
    
    private func configureQuestionForm() {
        
        questionInfos = SurveyQuestionsLoader(surveyInfo: surveyInfo).getQuestionInfos()
        loadParentViewModel(questions: questionInfos)
        
        self.hideKeyboardWhenTappedAround()
        
        fetchDelegateAndSaveToRealm(code: surveyInfo.code)
        
        subscribeListeningToSaveEvent()
    }
    
    private func subscribeListeningToSaveEvent() {
        self.listenToSaveEvent()
    }
    
    private func fetchDelegateAndSaveToRealm(code: String) {
        
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
                
                let delegateEmailScrambler = DelegateEmailScrambler(campaign: sSelf.surveyInfo.campaign)
                if !delegateEmailScrambler.shouldShowEmail() {
                    myDelegate.email = ""
                }
                
                let updatedSurvey = sSelf.surveyInfo.updated(withDelegate: myDelegate)
                
                DispatchQueue.main.async {
                    sSelf.saveAnswersToRealmAndUpdateSurveyInfo(surveyInfo: updatedSurvey,
                                                                answers: updatedSurvey.answers) //redundant....
                }
            })
            .disposed(by: bag)
    }
    
    @objc func doneWithOptionsIsTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func loadParentViewModel(questions: [PresentQuestionInfoProtocol]) {
        
        let helper = ViewInfoProvider(questions: questions, code: surveyInfo.code)
        let viewInfos = helper.getViewInfos()
        
        viewModel = QuestionsAnswersViewModel(viewInfos: viewInfos)
        viewItems = viewModel.getQuestionPageViewItems()
        drawScreen(viewItems: viewItems)
    }
    
    private func drawScreen(viewItems: [QuestionPageGetViewProtocol]) {
        _ = viewItems.map({
            stackView?.addArrangedSubview($0.getView())
        })
    }
    
    private func listenToSaveEvent() {
        let items = viewModel.getQuestionPageViewItems()
        
        let saveBtn = (items.first(where: {$0 is SaveBtnViewItem}) as! SaveBtnViewItem).button
        
        saveBtn.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] (_) in guard let strongSelf = self else {return}

                let myAnswers = strongSelf.answersUpdater.updateAnswers() // both actual + realm
                strongSelf.persistAnswersIfFormIsValid(strongSelf: strongSelf, answers: myAnswers)

            })
            .disposed(by: bag)
    }
    
    private func persistAnswersIfFormIsValid(strongSelf: QuestionsAnswersVC, answers: [MyAnswerProtocol]) {
        
        let validator = QA_Validation(surveyInfo: surveyInfo, questions: questions, answers: answers)
        
        if validator.questionsFormIsValid {
            
            strongSelf.navigationController?.popViewController(animated: true)
            
            saveAnswersToRealmAndUpdateSurveyInfo(surveyInfo: surveyInfo, answers: answers)
            
            let newReport = AnswersReport.init(surveyInfo: surveyInfo, answers: answers, success: false)
            self.answersWebReporter.report.accept(newReport)
            
        } else {
            strongSelf.showAlertFormNotValid(forQuestion: validator.invalidFieldQuestion)
        }
    }
    
    private func saveAnswersToRealmAndUpdateSurveyInfo(surveyInfo: SurveyInfo, answers: [MyAnswerProtocol]) {
        surveyInfo.save(answers: answers)
            .subscribe({ (saved) in
                print("answers saved to realm = \(saved)")
                self.surveyInfo = surveyInfo
            })
            .disposed(by: bag)
    }
    
    private func showAlertFormNotValid(forQuestion question: QuestionProtocol?) {
        
        let alertInfo = AlertInfo.getInfo(type: AlertInfoType.questionsFormNotValid)
        
        self.alert(alertInfo: alertInfo, preferredStyle: .alert)
            .subscribe(onNext: { _ in
                
                guard let question = question else { return }
                
                let scroller = ScrollViewScroller(scrollView: self.scrollView,
                                                  questions: self.questions)
                
                scroller.scrollTo(question: question)
                
                let attentioner = ScrollViewPayingAttentioner(scrollView: self.scrollView,
                                                              questions: self.questions)
                
                delay(0.05, closure: {
                    attentioner.payAttentionTo(question: question)
                })
                
            }).disposed(by: bag)
    }
    
}

extension QuestionsAnswersVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
}
