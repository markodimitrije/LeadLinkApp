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
    
    private var questionsWidthProvider = QuestionsAnswersTableWidthCalculatorFactory().makeWidthCalculator()
    private var viewmodelFactory: ViewmodelFactory!
    
    private lazy var viewStackerFactory = ViewStackerFactory.init(
        questionsWidthProvider: questionsWidthProvider,
        bag: bag,
        delegate: questionOptionsFromTextViewDelegate
    )
    
    @IBOutlet weak var tableView: UITableView!
    
    private var questions = [SurveyQuestion]()
    private var parentViewmodel: ParentViewModel!
    
    var webViewsAndViewSizesProvider: WebViewsAndViewSizesProvider!
    let localComponents = LocalComponentsViewFactory()
    
    var bag = DisposeBag()
    
    private var keyboardDelegate: QuestionsAnswersMovingKeyboardDelegate!
    
    private let answersWebReporter = AnswersReportsToWebState.init() // report to web (manage API and REALM if failed)

    private var myDataSource: QuestionsAnswersDataSource!
    private var myDelegate: QuestionsAnswersDelegate!
    
    lazy private var questionOptionsFromTextViewDelegate = QuestionOptionsFromTextViewDelegate.init(viewController: self, parentViewmodel: parentViewmodel)
    
    lazy private var answersUpdater: AnswersUpdating = AnswersUpdater.init(surveyInfo: surveyInfo,
                                                                           parentViewmodel: parentViewmodel)
    // API
    var surveyInfo: SurveyInfo! {
        didSet {
            self.viewmodelFactory = ViewmodelFactory(code: surveyInfo.code)
            configureQuestionForm()
            if oldValue == nil {
                subscribeListeningToSaveEvent()
            }
        }
    }
    
    private func configureQuestionForm() {
        
        questions = SurveyQuestionsLoader(surveyInfo: surveyInfo).getQuestions()
        loadParentViewModel(questions: questions)
        
        webViewsAndViewSizesProvider = WebViewsAndViewSizesProvider(questions: questions,
                                                                    viewmodels: parentViewmodel.childViewmodels,
                                                                    viewStackerFactory: viewStackerFactory)
        
        self.hideKeyboardWhenTappedAround()
        self.setUpKeyboardBehavior()
        
        fetchDelegateAndSaveToRealm(code: surveyInfo.code)
        tableView?.reloadData()
        
        loadTableViewDataSourceAndDelegate()
    }
    
    private func loadTableViewDataSourceAndDelegate() {
        
        myDataSource = QuestionsAnswersDataSource.init(viewController: self, questions: questions, webViewsAndViewSizesProvider: webViewsAndViewSizesProvider)
        myDelegate = QuestionsAnswersDelegate.init(viewController: self, questions: questions, webViewsAndViewSizesProvider: webViewsAndViewSizesProvider)
        
        self.tableView?.dataSource = myDataSource
        self.tableView?.delegate = myDelegate
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
    
    private func setUpKeyboardBehavior() {
        
        keyboardDelegate = QuestionsAnswersMovingKeyboardDelegate.init(keyboardChangeHandler: scrollFirstResponderToTopOfTableView)
        
    }
    
    private func scrollFirstResponderToTopOfTableView(verticalShift: CGFloat) {
    
        let firstResponder: UITableViewCell? = tableView.visibleCells.first(where: { cell -> Bool in
            let textControlObject = cell.locateClosestChild(ofType: UITextField.self) ?? cell.locateClosestChild(ofType: UITextView.self)
            guard let textControl = textControlObject else {
                return false
            }
            return textControl.isFirstResponder
        })
        
        guard let firstResponderCell = firstResponder else { return }

        // da li je od dropdowna ?? ako da, ponisti mu scroll...

        let isCellBelowHalfOfTheScreen = self.tableView.isCellBelowHalfOfTheScreen(cell: firstResponderCell)

        if isCellBelowHalfOfTheScreen {
            if verticalShift < 0 {
                delay(0.1) {
                    self.tableView.contentOffset.y += abs(2*verticalShift)
                }
            }
        }
        
    }
    
    @objc func doneWithOptionsIsTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func loadParentViewModel(questions: [SurveyQuestion]) {
        
        let childViewmodels = questions.compactMap { surveyQuestion -> Questanable? in
            return viewmodelFactory.makeViewmodel(surveyQuestion: surveyQuestion)
        }
        parentViewmodel = ParentViewModel.init(viewmodels: childViewmodels)
    }
    
    private func listenToSaveEvent() {
        
        localComponents.saveBtn.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] (_) in guard let strongSelf = self else {return}
                
                strongSelf.localComponents.saveBtn.startSpinner()
                let myAnswers = strongSelf.answersUpdater.updateAnswers() // both actual + realm
                strongSelf.persistAnswersIfFormIsValid(strongSelf: strongSelf, answers: myAnswers)
                
            })
            .disposed(by: bag)

    }
    
    private func persistAnswersIfFormIsValid(strongSelf: QuestionsAnswersVC, answers: [MyAnswer]) {
        
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
    
    private func saveAnswersToRealmAndUpdateSurveyInfo(surveyInfo: SurveyInfo, answers: [MyAnswer]) {
        surveyInfo.save(answers: answers)
            .subscribe({ (saved) in
                print("answers saved to realm = \(saved)")
                self.surveyInfo = surveyInfo
            })
            .disposed(by: bag)
    }
    
    private func showAlertFormNotValid(forQuestion question: PresentQuestion?) {
        
        let alertInfo = AlertInfo.getInfo(type: AlertInfoType.questionsFormNotValid)
        
        self.alert(alertInfo: alertInfo, preferredStyle: .alert)
            .subscribe(onNext: { _ in
                
                guard let question = question else { return }
                
                let helper = QuestionsDataSourceAndDelegateHelper(questions: self.questions,
                                                                  localComponents: self.localComponents)
                
                let scroller = TableViewScroller(tableView: self.tableView,
                                                 questions: self.questions.map({$0.question}),
                                                 helper: helper)
                
                scroller.scrollTo(question: question)
                
                self.localComponents.saveBtn.stopSpinner()
                
                let attentioner = TableViewPayingAttentioner(tableView: self.tableView,
                                                             questions: self.questions.map({$0.question}),
                                                             helper: helper)
                
                delay(0.5, closure: {
                    attentioner.payAttentionTo(question: question)
                })
                
            }).disposed(by: bag)
    }
    
}
