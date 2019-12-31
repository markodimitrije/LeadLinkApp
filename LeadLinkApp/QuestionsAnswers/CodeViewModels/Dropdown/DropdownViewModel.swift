//
//  DropdownViewModel.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

public class DropdownViewModel: NSObject {
    
    private let question: QuestionProtocol
    private var answer: MyAnswerProtocol?
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
    
    init(surveyQuestion: SurveyQuestionProtocol,
         viewFactory: GetViewProtocol,
         viewControllerFactory: ChooseOptionsProtocol) {
        
        self.question = surveyQuestion.getQuestion()
        self.answer = surveyQuestion.getAnswer()
        self.code = surveyQuestion.getCode()
        self.viewControllerFactory = viewControllerFactory

        self.view = viewFactory.getView()
        self.view.tag = surveyQuestion.getQuestion().qId
        
        super.init()
        
        self.view.findViews(subclassOf: UITextView.self).first!.delegate = self
        
        listenToDoneWithSelectedOptions()
        
        hideTextViewCursor()
    }
    
    private func listenToDoneWithSelectedOptions() {
                
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
}

extension DropdownViewModel: QuestionPageViewModelProtocol {
    
    func getView() -> UIView {
        return self.view
    }
    
    func getActualAnswer() -> MyAnswerProtocol? {
        let text = self.view.findViews(subclassOf: UITextView.self).first!.text
        let result = (text != self.question.qDesc) ? text : ""
        if answer != nil {
            answer?.content = [result ?? ""]
        } else {
            answer = MyAnswer(question: question, code: code, content: [result ?? ""], optionIds: nil)
        }
        return answer
    }
}

extension DropdownViewModel: UITextViewDelegate {
     
    public func textViewDidBeginEditing(_ textView: UITextView) {
        
        textView.resignFirstResponder()
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            UIApplication.topViewController()?.navigationController?.pushViewController(nextViewController, animated: true)
        } else {
            showOptionsAsPopover(vc: nextViewController, fromSourceRect: textView)
        }
        
        if textView.text == question.qDesc {
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
