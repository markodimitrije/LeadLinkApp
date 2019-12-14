//
//  QuestionOptionsFromTextViewDelegate.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 26/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class QuestionOptionsFromTextViewDelegate: NSObject, UITextViewDelegate {
    
    private var viewController: QuestionsAnswersVC
    private var parentViewmodel: ParentViewModel
    
    init(viewController: QuestionsAnswersVC, parentViewmodel: ParentViewModel) {
        self.viewController = viewController
        self.parentViewmodel = parentViewmodel
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        let chooseOptionsVcFactory = ChooseOptionsViewControllerFactory(appDependancyContainer: factory)
        
        let chooseOptionsVC = chooseOptionsVcFactory.makeFlatChooseOptionsVC()
        
        guard let childViewmodel = parentViewmodel.childViewmodels[textView.tag] as? SelectOptionTextFieldViewModel else {
            return
        }
        
        let navBarTitle = childViewmodel.question.headlineText
        chooseOptionsVC.navigationItem.title = navBarTitle

        let dataSourceAndDelegate = QuestionOptionsTableViewDataSourceAndDelegate(selectOptionTextViewModel: childViewmodel)
        chooseOptionsVC.dataSourceAndDelegate = dataSourceAndDelegate

        textView.textColor = .black
        textView.resignFirstResponder()
        
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
            
            //selfRef.webQuestionIdsToViewSizes[viewmodel.question.id] = textView.bounds.size
        
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
