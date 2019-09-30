//
//  QuestionsAnswersVC.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 13/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Realm
import RealmSwift

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
    let localComponents = LocalComponents()
    
    var bag = DisposeBag()
    
    private var keyboardDelegate: MovingKeyboardDelegate!
    
    private let answersReporter = AnswersReportsToWebState.init() // report to web (manage API and REALM if failed)

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
    
    private func configureQuestionForm() { print("Realm url: \(Realm.Configuration.defaultConfiguration.fileURL!)")
        
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
            .subscribe(onNext: { [weak self] result in
                guard let sSelf = self else {return}
                guard let delegate = result else { return }
                
                let updatedSurvey = sSelf.surveyInfo.updated(withDelegate: delegate)
                
                DispatchQueue.main.async {
                    sSelf.saveAnswersToRealmAndUpdateSurveyInfo(surveyInfo: updatedSurvey,
                                                                answers: updatedSurvey.answers) //redundant....
                }
            })
            .disposed(by: bag)
    }
    
    private func setUpKeyboardBehavior() {
        
        keyboardDelegate = MovingKeyboardDelegate.init(keyboardChangeHandler: scrollFirstResponderToTopOfTableView)
        
    }
    
    private func scrollFirstResponderToTopOfTableView(verticalShift: CGFloat) {
        
        print("scrollFirstResponderToTopOfTableView is CALLED ! ! !  ! !  !")
        
        let firstResponder: UITableViewCell? = tableView.visibleCells.first(where: { cell -> Bool in
            let textControlObject = cell.locateClosestChild(ofType: UITextField.self) ?? cell.locateClosestChild(ofType: UITextView.self)
            guard let textControl = textControlObject else {
                return false
            }
            return textControl.isFirstResponder
        })
        
        guard let firstResponderCell = firstResponder else { return }
        
        let isCellBelowHalfOfTheScreen = self.tableView.isCellBelowHalfOfTheScreen(cell: firstResponderCell)
        
        if isCellBelowHalfOfTheScreen {
            if verticalShift < 0 {
                self.tableView.contentOffset.y += abs(2*verticalShift)
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
                
                let myAnswers = strongSelf.answersUpdater.updateAnswers() // both actual + realm
                strongSelf.saveAnswersIfFormIsValid(strongSelf: strongSelf, answers: myAnswers)
                
            })
            .disposed(by: bag)

    }
    
    private func saveAnswersIfFormIsValid(strongSelf: QuestionsAnswersVC, answers: [MyAnswer]) {
        
        let validator = Validation(surveyInfo: surveyInfo, questions: questions, answers: answers)

        if validator.questionsFormIsValid {
            
            strongSelf.navigationController?.popViewController(animated: true)
            
            saveAnswersToRealmAndUpdateSurveyInfo(surveyInfo: surveyInfo, answers: answers)
            
            let newReport = AnswersReport.init(surveyInfo: surveyInfo, answers: answers, success: false)
            answersReporter.report.accept(newReport)
            
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
                
                let attentioner = TableViewPayingAttentioner(tableView: self.tableView,
                                                             questions: self.questions.map({$0.question}),
                                                             helper: helper)
                
                delay(0.5, closure: {
                    attentioner.payAttentionTo(question: question)
                })
                
            }).disposed(by: bag)
    }
    
}

enum QuestionsAnswersSectionType: String {
    case noGroupAssociated = " "
    case localComponentsGroupName = "Privacy Policy"
}
