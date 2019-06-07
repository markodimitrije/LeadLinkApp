//
//  QuestionsAnswersDataSourceAndDelegate.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 07/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Realm
import RealmSwift

class QuestionsAnswersDataSourceAndDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let factory = AppDependencyContainer.init()
    lazy private var dataSourceHelper = QuestionsDataSourceAndDelegateHelper(questions: questions)
    
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

extension QuestionsAnswersDataSourceAndDelegate: UITextViewDelegate {
    
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
