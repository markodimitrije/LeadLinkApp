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
    
    private var surveyQuestions = [SurveyQuestionProtocol]()
    var questions: [QuestionProtocol] {
        return surveyQuestions.map {$0.getQuestion()}
    }
    var viewModel: QuestionsAnswersViewModel!
    lazy private var obsDelegate: Observable<Delegate?> = {
        return DelegatesRemoteAPI.shared.getDelegate(withCode: surveyInfo.code)
    }()
    
    lazy private var keyboardHandler: KeyboardHandling = {
        return ScrollViewKeyboardHandler(scrollView: scrollView)
    }()
    
    private let bag = DisposeBag()
    
    // API
    var surveyInfo: SurveyInfo! {
        didSet {
            guard surveyInfo != nil, viewModel != nil else {return}
            if oldValue != nil {
                configureQuestionForm()
            }
        }
    }
    
    override func viewDidLoad() { super.viewDidLoad()
        self.scrollView.delegate = self
        keyboardHandler.registerForKeyboardEvents()
        configureQuestionForm()
    }
    
    private func configureQuestionForm() {
        
        self.hideKeyboardWhenTappedAround()
        
        stackView?.removeAllSubviews()
        surveyQuestions = SurveyQuestionsLoader(surveyInfo: surveyInfo).getSurveyQuestions()
        loadParentViewModel(questions: surveyQuestions)
        subscribeListeningToSaveEvent()
    }
    
    private func subscribeListeningToSaveEvent() {
        viewModel.formIsValid
        .subscribe(onNext: { (question) in
            if question == nil {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.showAlertFormNotValid(forQuestion: question)
            }
        })
        .disposed(by: bag)
    }
    
    @objc func doneWithOptionsIsTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func loadParentViewModel(questions: [SurveyQuestionProtocol]) {
        
        let helper = ViewInfoProvider(questions: questions, code: surveyInfo.code)
        let viewInfos = helper.getViewInfos()
        
        let getViewItemsWorker = QuestionPageGetViewItemsWorker(viewInfos: viewInfos)
        let answersWebReporter = AnswersReportsToWebState()
        viewModel = QuestionsAnswersViewModel.init(getViewItemsWorker: getViewItemsWorker,
                                                   answersWebReporterWorker: answersWebReporter,
                                                   obsDelegate: obsDelegate)
        
        let viewItems = viewModel.getQuestionPageViewItems()
        drawScreen(viewItems: viewItems)
    }
    
    private func drawScreen(viewItems: [QuestionPageGetViewProtocol]) {
        _ = viewItems.map({
            stackView?.addArrangedSubview($0.getView())
        })
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

struct QuestionsAnswersViewModelFactory {
    func make(surveyInfo: SurveyInfo, obsDelegate: Observable<Delegate?>) -> QuestionsAnswersViewModel {
        let questions = surveyInfo.surveyQuestions
        let helper = ViewInfoProvider(questions: questions, code: surveyInfo.code)
        let viewInfos = helper.getViewInfos()
        
        let getViewItemsWorker = QuestionPageGetViewItemsWorker(viewInfos: viewInfos)
        let answersWebReporter = AnswersReportsToWebState()
        let viewModel = QuestionsAnswersViewModel.init(getViewItemsWorker: getViewItemsWorker,
                                                       answersWebReporterWorker: answersWebReporter,
                                                       obsDelegate: obsDelegate)
        return viewModel
    }
}
