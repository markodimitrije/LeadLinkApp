//
//  DropdownViewModel.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

class DropdownViewModel: NSObject, QuestionPageViewModelProtocol {
    
    private let question: PresentQuestion
    private var answer: MyAnswer?
    private let code: String
    
    fileprivate let viewControllerFactory: ChooseOptionsProtocol
    var actualVC = UIApplication.topViewController()!
    lazy fileprivate var nextViewController: UIViewController = {
        return viewControllerFactory.getViewController()
    }()
    
    private var view: UIView!
    private var textView: UITextView {
        return view.findViews(subclassOf: UITextView.self).first!
    }
    private let bag = DisposeBag()
    
    init(presentQuestionInfo: PresentQuestionInfoProtocol,
         viewFactory: GetViewProtocol,
         viewControllerFactory: ChooseOptionsProtocol) {
        
        self.question = presentQuestionInfo.getQuestion()
        self.answer = presentQuestionInfo.getAnswer()
        self.code = presentQuestionInfo.getCode()
        self.viewControllerFactory = viewControllerFactory

        self.view = viewFactory.getView()
        self.view.tag = presentQuestionInfo.getQuestion().id
        
        super.init()
        
        self.view.findViews(subclassOf: UITextView.self).first!.delegate = self
        
        hookToSelectedOptions()
        
        hideTextViewCursor()
    }
    
    private func hookToSelectedOptions() {
                
        viewControllerFactory.getChosenOptions()
            .subscribe(onNext: { [weak self] selectedOptions in
                self?.updateText(selectedOptions: selectedOptions)
                self?.navigateBackToQuestionsScreen()
            })
            .disposed(by: bag)
    }
    
    private func hideTextViewCursor(){
        self.textView.tintColor = .clear
    }
    
    private func updateText(selectedOptions: [String]) {
        let optionsText = selectedOptions.reduce("", { ($0 + "\n" + $1) })
        let text = NSString(string: optionsText).substring(from: 1)
        self.textView.text = text
    }
    
    private func navigateBackToQuestionsScreen() {
        let optionsVC = UIApplication.topViewController()
        if UIDevice.current.userInterfaceIdiom == .phone {
            optionsVC?.navigationController?.popViewController(animated: true)
        } else {
            optionsVC?.dismiss(animated: true, completion: nil)
        }
    }
    
    func getView() -> UIView {
        return self.view
    }
    
    func getActualAnswer() -> MyAnswer? {
        let text = view.findViews(subclassOf: UITextView.self).first!.text
        let result = (text != self.question.description) ? text : ""
        if answer != nil {
            answer?.content = [result ?? ""]
        } else {
            answer = MyAnswer(question: question, code: code, content: [result ?? ""], optionIds: nil)
        }
        return answer
    }
}

extension DropdownViewModel: UITextViewDelegate {
     
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        textView.resignFirstResponder()
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            UIApplication.topViewController()?.navigationController?.pushViewController(nextViewController, animated: true)
        } else {
            showOptionsAsPopover(vc: nextViewController, fromSourceRect: textView)
        }
        
        if textView.text == question.description {
            self.deletePlaceholderAndSetTxtColorToBlack(textView: textView)
        }
        
    }
    private func deletePlaceholderAndSetTxtColorToBlack(textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    private func showOptionsAsPopover(vc: UIViewController, fromSourceRect source: UIView) {
        let popoverContent = vc
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = .popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: 400,height: 600)
        let presentationVC = actualVC
        popover?.delegate = presentationVC as! UIPopoverPresentationControllerDelegate
        popover?.sourceView = presentationVC.view
        popover?.sourceRect = source.bounds
        
        presentationVC.present(nav, animated: true, completion: nil)
    }
}
