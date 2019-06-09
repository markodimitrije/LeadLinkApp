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
    
    private lazy var viewFactory = ViewFactory.init(bounds: self.view.bounds)
    private var viewmodelFactory: ViewmodelFactory!
    
    private lazy var viewStackerFactory = ViewStackerFactory.init(viewFactory: viewFactory,
                                                                  bag: bag,
                                                                  delegate: myDataSourceAndDelegate)
    
    @IBOutlet weak var tableView: UITableView!
    
    var questions = [SingleQuestion]()
    
    var parentViewmodel: ParentViewModel!
    var allQuestionsViews = [Int: UIView]()
    var questionIdsToViewSizes = [Int: CGSize]()
    var saveBtn: UIButton!
    
    var bag = DisposeBag()
    
    private let answersReporter = AnswersReportsToWebState.init() // report to web (manage API and REALM if failed)
    
    lazy private var myDataSourceAndDelegate = QuestionsAnswersDataSourceAndDelegate.init(viewController: self)
    
    private var keyboardDelegate: MovingKeyboardDelegate?
    
    // API
    var surveyInfo: SurveyInfo! {
        didSet {
            self.viewmodelFactory = ViewmodelFactory(code: surveyInfo.code)
            configureQuestionForm()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureQuestionForm()
    }
    
    private func configureQuestionForm() {
        
        self.hideKeyboardWhenTappedAround()
        
        print("Realm url: \(Realm.Configuration.defaultConfiguration.fileURL!)")
        
        self.saveBtn = SaveButton()
        
        loadQuestions(surveyInfo: surveyInfo)
        
        loadParentViewModel(questions: questions)
        
        loadViewStackerAndComponentSizes()
        
        listenToSaveEvent(existingAnswers: surveyInfo.answers)
        
        myDataSourceAndDelegate = QuestionsAnswersDataSourceAndDelegate.init(viewController: self)
        
        self.tableView.dataSource = myDataSourceAndDelegate
        self.tableView.delegate = myDataSourceAndDelegate
        
        setUpKeyboardBehavior()
        
        fetchDelegateAndSaveToRealm(code: surveyInfo.code)
        
        tableView?.reloadData()
    }
    
    private func fetchDelegateAndSaveToRealm(code: String) {
        
        guard shouldPrepopulateDelegateData(code: code) else { return }

        let oNewDelegate = DelegatesRemoteAPI.shared.getDelegate(withCode: code)
        
        oNewDelegate
            .subscribe(onNext: { [weak self] result in
                guard let sSelf = self else {return}
                guard let delegate = result else { return }
                
                let updatedSurvey = sSelf.surveyInfo.updated(withDelegate: delegate)
                
                DispatchQueue.main.async {
                    sSelf.saveAnswers(surveyInfo: updatedSurvey, answers: updatedSurvey.answers) //redundant....
                }
                
            })
            .disposed(by: bag)
        
    }
    
    private func shouldPrepopulateDelegateData(code: String) -> Bool {
        let hasRealmAnswers = surveyInfo.doesCodeSavedInRealmHasAnyAnswers(codeValue: code)
        let hasConsent = surveyInfo.hasConsent
        return !hasRealmAnswers && hasConsent
    }
    
    private func setUpKeyboardBehavior() {
        
        keyboardDelegate = MovingKeyboardDelegate.init(keyboardChangeHandler: { (verticalShift) in
            
            let firstResponder: UITableViewCell? = self.tableView.visibleCells.first(where: { cell -> Bool in
                let textControlObject = cell.locateClosestChild(ofType: UITextField.self) ?? cell.locateClosestChild(ofType: UITextView.self)
                guard let textControl = textControlObject else {
                    return false
                }
                return textControl.isFirstResponder
            })
            
            guard let firstResponderCell = firstResponder,
                 let firstResponderIdexPath = self.tableView.indexPath(for: firstResponderCell) else {
                    return
            }
            
            var countOfCellsInSection = 0
            if let sectionIndex = self.tableView.indexPath(for: firstResponderCell)?.section {
                countOfCellsInSection = self.tableView.numberOfRows(inSection: sectionIndex)
            }
            
            let isCellBelowHalfOfTheScreen = self.tableView.isCellBelowHalfOfTheScreen(cell: firstResponderCell)
            
            if isCellBelowHalfOfTheScreen {
                if verticalShift < 0 {
//
                    if let firstCellAbove = self.tableView.getFirstCellAbove(cell: firstResponderCell),
                        let newIp = self.tableView.indexPath(for: firstCellAbove) {
                            self.tableView.scrollToRow(at: newIp, at: .top, animated: true)
                    } else {
                        fatalError()
                    }
                    
                } else {
                    if firstResponderIdexPath.row + 1 < countOfCellsInSection {
                        let newIp = IndexPath(row: firstResponderIdexPath.row + 1, section: firstResponderIdexPath.section)
                        self.tableView.scrollToRow(at: newIp, at: UITableView.ScrollPosition.bottom, animated: true)
                    } else {
                        print("scroll to next section!")
                    }
                }
            }
            
        })
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
        
        self.questions = questions.map { question -> SingleQuestion in
            let rAnswer = rAnswers.first(where: {$0.questionId == question.id})
            return SingleQuestion.init(question: question, realmAnswer: rAnswer)
        }
        
    }
    
    private func loadParentViewModel(questions: [SingleQuestion]) {
        
        let childViewmodels = questions.compactMap { singleQuestion -> Questanable? in
            return viewmodelFactory.makeViewmodel(singleQuestion: singleQuestion) as? Questanable
        }
        parentViewmodel = ParentViewModel.init(viewmodels: childViewmodels)
    }
    
    private func loadViewStackerAndComponentSizes() {
        
        _ = questions.map({ singleQuestion -> Void in
            let questionId = singleQuestion.question.id
            guard let viewmodel = parentViewmodel.childViewmodels[questionId] else {return}
            let singleQuestionStackerView = viewStackerFactory.drawStackView(questionsOfSameType: [singleQuestion],
                                                                             viewmodel: viewmodel)
            allQuestionsViews[questionId] = singleQuestionStackerView
            questionIdsToViewSizes[questionId] = singleQuestionStackerView.bounds.size
            
        })
        
    }
    
    private func listenToSaveEvent(existingAnswers:[MyAnswer] = []) {
        
        saveBtn.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] (_) in guard let strongSelf = self else {return}
                
                var answers = [MyAnswer]()
//                var answers = existingAnswers
                
                var answersIds = answers.map({$0.id})
                
                func addOrUpdateAnswers(withAnswer answer: MyAnswer) {
                    
                    guard let content = answer.content.first, content != "" else {
                        return
                    }
                    if let index = answersIds.index(of: answer.id) {
                        answers.remove(at: index)
                    }
                    answers.append(answer)
                }
                
                _ = self?.parentViewmodel.childViewmodels.compactMap({ viewmodelDict in
                    
                    let viewmodel = viewmodelDict.value
                    
                    if let viewmodel = viewmodel as? RadioViewModel, var answer = viewmodel.answer {
                        answer.code = strongSelf.surveyInfo.code
                        addOrUpdateAnswers(withAnswer: answer)
                    } else if let viewmodel = viewmodel as? RadioWithInputViewModel, var answer = viewmodel.answer {
                        answer.code = strongSelf.surveyInfo.code
                        addOrUpdateAnswers(withAnswer: answer)
                    } else if let viewmodel = viewmodel as? CheckboxViewModel, var answer = viewmodel.answer {
                        answer.code = strongSelf.surveyInfo.code
                        addOrUpdateAnswers(withAnswer: answer)
                    } else if let viewmodel = viewmodel as? CheckboxWithInputViewModel, var answer = viewmodel.answer {
                        answer.code = strongSelf.surveyInfo.code
                        addOrUpdateAnswers(withAnswer: answer)
                    } else if let viewmodel = viewmodel as? SwitchBtnsViewModel, var answer = viewmodel.answer {
                        answer.code = strongSelf.surveyInfo.code
                        addOrUpdateAnswers(withAnswer: answer)
                    } else if let viewmodel = viewmodel as? LabelWithTextFieldViewModel, var answer = viewmodel.answer {
                        answer.code = strongSelf.surveyInfo.code
                        addOrUpdateAnswers(withAnswer: answer)
                    } else if let viewmodel = viewmodel as? SelectOptionTextFieldViewModel, var answer = viewmodel.answer {
                        answer.code = strongSelf.surveyInfo.code
                        addOrUpdateAnswers(withAnswer: answer)
                    } else {
                        print("o-o, unknown type of viewmodel ?!?!?!, viewmodel = \(viewmodel)")
                    }
                })
                
                strongSelf.saveAnswersIfFormIsValid(strongSelf: strongSelf, answers: answers)
                
            })
            .disposed(by: bag)
    }
    
    private func saveAnswersIfFormIsValid(strongSelf: QuestionsAnswersVC, answers: [MyAnswer]) {
        //let validator = Validation(answers: answers) // hard-coded, ne obraca paznju da li je email u email txt !
        let validator = Validation(surveyInfo: surveyInfo, questions: questions, answers: answers) // hard-coded, ne obraca paznju da li je email u email txt !
        if validator.questionsFormIsValid {
            
            saveAnswers(surveyInfo: surveyInfo, answers: answers)
            
            let newReport = AnswersReport.init(surveyInfo: surveyInfo, answers: answers, success: false)
            answersReporter.report.accept(newReport)
            
            strongSelf.navigationController?.popViewController(animated: true)
        } else {
            strongSelf.showAlertFormNotValid()
        }
    }
    
    private func saveAnswers(surveyInfo: SurveyInfo, answers: [MyAnswer]) {
        surveyInfo.save(answers: answers)
            .subscribe({ (saved) in
                print("answers saved to realm = \(saved)")
                self.surveyInfo = surveyInfo
            })
            .disposed(by: bag)
    }
    
    private func showAlertFormNotValid() {
        let alertInfo = AlertInfo.getInfo(type: AlertInfoType.questionsFormNotValid)
        self.alert(alertInfo: alertInfo, preferredStyle: .alert)
            .subscribe(onNext: { _ in
            }).disposed(by: bag)
    }
    
}



enum SectionType: String {
    case noGroupAssociated = " "
    case saveBtn = "  "
}


