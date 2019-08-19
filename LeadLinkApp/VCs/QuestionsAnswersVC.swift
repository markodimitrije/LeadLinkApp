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

class QuestionsAnswersVC: UIViewController, UIPopoverPresentationControllerDelegate, Storyboarded {//}, RadioBtnListener {
    
    private var questionsWidthProvider = QuestionsAnswersTableWidthCalculatorFactory().makeWidthCalculator()
    private var viewmodelFactory: ViewmodelFactory!
    
    private lazy var viewStackerFactory = ViewStackerFactory.init(
        questionsWidthProvider: questionsWidthProvider,
        bag: bag,
        delegate: questionOptionsFromTextViewDelegate
    )
    
    @IBOutlet weak var tableView: UITableView!
    
    var questions = [SurveyQuestion]()
    
    var parentViewmodel: ParentViewModel!
    var webQuestionViews = [Int: UIView]()
    var webQuestionIdsToViewSizes = [Int: CGSize]()
    
    let localComponents = LocalComponents()
    
    var bag = DisposeBag()
    
    private let answersReporter = AnswersReportsToWebState.init() // report to web (manage API and REALM if failed)

    lazy private var myDataSource = QuestionsAnswersDataSource.init(viewController: self)
    lazy private var myDelegate = QuestionsAnswersDelegate.init(viewController: self)
    lazy private var questionOptionsFromTextViewDelegate = QuestionOptionsFromTextViewDelegate.init(viewController: self)
    
    private var keyboardDelegate: MovingKeyboardDelegate?
    
    lazy private var answersUpdater: AnswersUpdating = AnswersUpdater.init(surveyInfo: surveyInfo,
                                                                           parentViewmodel: parentViewmodel)
    
    // API
    var surveyInfo: SurveyInfo! {
        didSet {
            self.viewmodelFactory = ViewmodelFactory(code: surveyInfo.code)
            configureQuestionForm()
        }
    }
    
    private func configureQuestionForm() { print("Realm url: \(Realm.Configuration.defaultConfiguration.fileURL!)")
        
        self.hideKeyboardWhenTappedAround()
        
        loadQuestions(surveyInfo: surveyInfo)
        
        loadParentViewModel(questions: questions)
        
        loadViewStackerAndComponentSizes()
        
        listenToSaveEvent()
        
        self.tableView.dataSource = myDataSource
        self.tableView.delegate = myDelegate
        
        setUpKeyboardBehavior()
        
        fetchDelegateAndSaveToRealm(code: surveyInfo.code)
        
        tableView?.reloadData()
    }
    
    private func fetchDelegateAndSaveToRealm(code: String) {
        
        let decisioner = PrepopulateDelegateDataDecisioner.init(surveyInfo: surveyInfo, codeToCheck: code)
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
                
                let ip = self.tableView.indexPath(for: firstResponderCell)!
                self.tableView.scrollToRow(at: ip, at: .top, animated: true)
                
            }
            
        }
        
    }
    
    @objc func doneWithOptionsIsTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func loadQuestions(surveyInfo: SurveyInfo?) {
        
        guard let surveyInfo = surveyInfo else {return}
        
        let questions = surveyInfo.campaign.questions
        let rAnswers = surveyInfo.answers.map { myAnswer -> RealmAnswer in
            let rAnswer = RealmAnswer()
            rAnswer.updateWith(answer: myAnswer)
            return rAnswer
        }
        
        self.questions = questions.map { question -> SurveyQuestion in
            let rAnswer = rAnswers.first(where: {$0.questionId == question.id})
            return SurveyQuestion.init(question: question, realmAnswer: rAnswer)
        }
        
    }
    
    private func loadParentViewModel(questions: [SurveyQuestion]) {
        
        let childViewmodels = questions.compactMap { surveyQuestion -> Questanable? in
            return viewmodelFactory.makeViewmodel(surveyQuestion: surveyQuestion)
        }
        parentViewmodel = ParentViewModel.init(viewmodels: childViewmodels)
    }
    
    private func loadViewStackerAndComponentSizes() {
        
        let orderedQuestions = questions.sorted(by: {first, second in
            first.question.order < second.question.order
        })
        
        _ = orderedQuestions.map { surveyQuestion -> Void in
            let questionId = surveyQuestion.question.id
            guard let viewmodel = parentViewmodel.childViewmodels[questionId] else {return}
            
            let questionView = viewStackerFactory.getStackerView(surveyQuestion: surveyQuestion,
                                                                 viewmodel: viewmodel)
            
            webQuestionViews[questionId] = questionView
            webQuestionIdsToViewSizes[questionId] = questionView.bounds.size
            
        }
        
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

