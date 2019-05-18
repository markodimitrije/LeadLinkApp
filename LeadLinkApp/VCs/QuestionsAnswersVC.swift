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

class QuestionsAnswersVC: UIViewController, UIPopoverPresentationControllerDelegate, Storyboarded {//}, RadioBtnListener {
    
    private lazy var viewFactory = ViewFactory.init(bounds: self.view.bounds)
    private let viewmodelFactory = ViewmodelFactory.init()
    private lazy var viewStackerFactory = ViewStackerFactory.init(viewFactory: viewFactory,
                                                                  bag: bag,
                                                                  delegate: myDataSourceAndDelegate)
    
    @IBOutlet weak fileprivate var tableView: UITableView!
    
    fileprivate var questions = [SingleQuestion]()
    fileprivate var allQuestionsViews = [Int: UIView]()
    
    fileprivate var parentViewmodel: ParentViewModel!
    fileprivate var questionIdsToViewSizes = [Int: CGSize]()
    fileprivate var saveBtn: UIButton!
    fileprivate var bag = DisposeBag()
    
    lazy private var myDataSourceAndDelegate = ViewControllerDataSourceAndDelegate.init(viewController: self)
    
    // API
    var surveyInfo: SurveyInfo! {
        didSet {
            loadQuestions(surveyInfo: surveyInfo)
        }
    }
    
    override func viewDidLoad() { super.viewDidLoad()
        
        self.saveBtn = SaveButton()
        
        loadParentViewModel(questions: questions)
        
        loadViewStackerAndComponentSizes()
        
        listenToSaveEvent()
        
        myDataSourceAndDelegate = ViewControllerDataSourceAndDelegate.init(viewController: self)
        
        self.tableView.dataSource = myDataSourceAndDelegate
        self.tableView.delegate = myDataSourceAndDelegate
        
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
    
    private func listenToSaveEvent() {
        
        saveBtn.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] (_) in guard let strongSelf = self else {return}
                
                var answers = [MyAnswer]()
                
                _ = self?.parentViewmodel.childViewmodels.compactMap({ viewmodelDict in
                    
                    let viewmodel = viewmodelDict.value
                    
                    if let viewmodel = viewmodel as? RadioViewModel, var answer = viewmodel.answer {
                        answer.code = strongSelf.surveyInfo.code
                        answers.append(answer)
                    } else if let viewmodel = viewmodel as? RadioWithInputViewModel, var answer = viewmodel.answer {
                        answer.code = strongSelf.surveyInfo.code
                        answers.append(answer)
                    } else if let viewmodel = viewmodel as? CheckboxViewModel, var answer = viewmodel.answer {
                        answer.code = strongSelf.surveyInfo.code
                        answers.append(answer)
                    } else if let viewmodel = viewmodel as? CheckboxWithInputViewModel, var answer = viewmodel.answer {
                        answer.code = strongSelf.surveyInfo.code
                        answers.append(answer)
                    } else if let viewmodel = viewmodel as? SwitchBtnsViewModel, var answer = viewmodel.answer {
                        answer.code = strongSelf.surveyInfo.code
                        answers.append(answer)
                    } else if let viewmodel = viewmodel as? LabelWithTextFieldViewModel, var answer = viewmodel.answer {
                        answer.code = strongSelf.surveyInfo.code
                        answers.append(answer)
                    } else if let viewmodel = viewmodel as? SelectOptionTextFieldViewModel, var answer = viewmodel.answer {
                        answer.code = strongSelf.surveyInfo.code
                        print("prepoznao VM, LabelWithTextFieldViewModel.answer = \(String(describing: viewmodel.answer))")
                        answers.append(answer)
                    } else {
                        print("o-o, unknown type of viewmodel ?!?!?!")
                    }
                })
                
                let validator = Validation(answers: answers) // hard-coded, ne obraca paznju da li je email u email txt !
                if validator.hasValidEmail {
                    strongSelf.surveyInfo.save(answers: answers)
                        .subscribe({ (saved) in
                            print("answers saved to realm = \(saved)")
                        }).disposed(by: strongSelf.bag)

                    strongSelf.navigationController?.popViewController(animated: true)
                } else {
                    strongSelf.showAlertFormNotValid()
                }
                
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

class ViewControllerDataSourceAndDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let factory = AppDependencyContainer.init()
    lazy private var dataSourceHelper = ViewControllerDataSourceAndDelegateHelper(questions: questions)
    
    private var viewController: QuestionsAnswersVC
    
    private var questions: [SingleQuestion] {return viewController.questions}
    private var allQuestionsStackerViews: [Int: UIView] {return viewController.allQuestionsViews}
    private var questionIdsViewSizes: [Int: CGSize] {return viewController.questionIdsToViewSizes}
    private var parentViewmodel: ParentViewModel {return viewController.parentViewmodel}
    private var saveBtn: UIButton {return viewController.saveBtn}
    
    init(viewController: QuestionsAnswersVC) {
        self.viewController = viewController
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { // koliko imas different groups ?
        
        return dataSourceHelper.numberOfDifferentGroups()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceHelper.itemsInGroupWith(index: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let groupNames = dataSourceHelper.groupNames()
        if section == groupNames.count {
            return SectionType.saveBtn.rawValue
        } else {
            return dataSourceHelper.groupNames()[section]
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.removeAllSubviews()
        
        if let questionId = dataSourceHelper.questionId(indexPath: indexPath) {
            if let stackerView = allQuestionsStackerViews[questionId] {
                stackerView.frame = cell.bounds
                cell.addSubview(stackerView)
            }
        } else { // save btn
            saveBtn.center = CGPoint.init(x: cell.bounds.midX, y: cell.bounds.midY)
            cell.addSubview(saveBtn)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let questionId = dataSourceHelper.questionId(indexPath: indexPath) else {
            return saveBtn.bounds.height
        }
        
        let cellHeight = questionIdsViewSizes[questionId]?.height ?? CGFloat.init(0) // bolje neki backup... hard-coded
        
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section != (tableView.numberOfSections - 1) else {return nil}
        return dataSourceHelper.footerView(sectionIndex: section, tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableRowHeightCalculator.getFooterHeightForDeviceType()
    }
    
}

extension ViewControllerDataSourceAndDelegate: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        let chooseOptionsVC = factory.makeFlatChooseOptionsVC()
        
        guard let childViewmodel = parentViewmodel.childViewmodels[textView.tag] as? SelectOptionTextFieldViewModel else {
            return
        }
        
        let navBarTitle = childViewmodel.question.headlineText
        chooseOptionsVC.navigationItem.title = navBarTitle
        
        let dataSourceAndDelegate = QuestionOptionsTableViewDataSourceAndDelegate(selectOptionTextViewModel: childViewmodel)
        chooseOptionsVC.dataSourceAndDelegate = dataSourceAndDelegate
        
        viewController.tableView.reloadData()
        
        chooseOptionsVC.doneWithOptions.subscribe(onNext: { [weak self] (dataSource) in
            guard let sSelf = self else {return}
            sSelf.reloadTableViewAndUpdateModel(selfRef: sSelf.viewController, //sSelf,
                forDataSource: dataSource as? QuestionOptionsTableViewDataSourceAndDelegate,
                viewmodel: childViewmodel,
                textView: textView)
        }).disposed(by: viewController.bag)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            viewController.navigationController?.pushViewController(chooseOptionsVC, animated: true)
        } else {
            showOptionsAsPopover(vc: chooseOptionsVC, fromSourceRect: textView)
        }
        
        textView.resignFirstResponder()
    }
    
    private func showOptionsAsPopover(vc: UIViewController, fromSourceRect source: UIView) {
        let popoverContent = vc
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = .popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: 400,height: 600)
        popover?.delegate = self.viewController
        popover?.sourceView = self.viewController.view
        popover?.sourceRect = source.bounds
        
        self.viewController.present(nav, animated: true, completion: nil)
    }
    
    private func reloadTableViewAndUpdateModel(selfRef: QuestionsAnswersVC,
                                               forDataSource dataSource: QuestionOptionsTableViewDataSourceAndDelegate?,
                                               viewmodel: SelectOptionTextFieldViewModel,
                                               textView: UITextView) {
        
        if let dataSource = dataSource {
            navigateBackFrom(optionsVC: selfRef)
            guard let newContent = dataSource.observableAnswer.value?.content else {return}
            viewmodel.answer?.content = newContent
            textView.text = newContent.reduce("", { ($0 + "\n" + $1) })
            
            (textView as? OptionsTextView)?.formatLayout(accordingToOptions: newContent)
            
            selfRef.questionIdsToViewSizes[viewmodel.question.id] = textView.bounds.size
            selfRef.tableView.reloadData()
        }
        
    }
    private func navigateBackFrom(optionsVC: UIViewController) {
        if UIDevice.current.userInterfaceIdiom == .phone {
            optionsVC.navigationController?.popViewController(animated: true)
        } else {
            optionsVC.dismiss(animated: true, completion: nil)
        }
        
    }
}

struct ViewControllerDataSourceAndDelegateHelper {
    
    private var orderedQuestions = [PresentQuestion]()
    
    lazy private var orderedGroups = orderedQuestions.map { question -> String in
        if itemHasNoGroup(question: question) {
            return SectionType.noGroupAssociated.rawValue
        } else {
            return question.group!
        }
        }.unique() + [SectionType.saveBtn.rawValue]
    
    init(questions: [SingleQuestion]) {
        self.orderedQuestions = questions.map {$0.question}.sorted(by: <)
    }
    
    mutating func numberOfDifferentGroups() -> Int {
        return orderedGroups.count
    }
    
    mutating func groupNames() -> [String] {
        return orderedGroups
    }
    
    mutating func questionsInGroupWith(index: Int) -> [PresentQuestion]? {
        if index == orderedGroups.count - 1 {return nil} // last section nema questions, u njemu je SAVE BTN
        if orderedGroups[index] != SectionType.noGroupAssociated.rawValue {
            return questionsInGroup(withIndex: index)
        } else {
            return questionsWithNoGroup()
        }
    }
    
    mutating func itemsInGroupWith(index: Int) -> Int {
        guard let questions = questionsInGroupWith(index: index) else {return 1} // ako nemas questions onda si SAVE BTN
        return questions.count
    }
    
    mutating func questionId(indexPath: IndexPath) -> Int? {
        guard let questions = questionsInGroupWith(index: indexPath.section) else {return nil}
        return questions[indexPath.row].id
    }
    
    mutating private func questionsInGroup(withIndex index: Int) -> [PresentQuestion] {
        let group = orderedGroups[index]
        let questions = orderedQuestions.filter {$0.group == group}.sorted(by: <)
        return questions
    }
    
    mutating private func questionsWithNoGroup() -> [PresentQuestion] {
        return orderedQuestions.filter {$0.group == nil || $0.group == ""}
    }
    
    private func itemHasNoGroup(question: PresentQuestion) -> Bool {
        return question.group == nil || question.group == ""
    }
    
    func footerView(sectionIndex: Int, tableView: UITableView) -> UIView {
        let size = footerViewSize(sectionIndex: sectionIndex, tableView: tableView)
        let rect = CGRect.init(origin: CGPoint.zero, size: size) // hard-coded ??
        return QuestionGroupFooterView.init(frame: rect)
    }
    
    private func footerViewSize(sectionIndex: Int, tableView: UITableView) -> CGSize {
        return CGSize.init(width: tableView.bounds.width,
                           height: tableRowHeightCalculator.getFooterHeightForDeviceType())
    }
    
}

enum SectionType: String {
    case noGroupAssociated = " "
    case saveBtn = "  "
}
