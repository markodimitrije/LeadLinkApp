//
//  CheckboxInputViewModel.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class CheckboxInputViewModel: NSObject, QuestionPageViewModelProtocol {
    
    private var question: PresentQuestion
    private var answer: MyAnswer?
    private var code: String = ""
    
    private var view: UIView!
    private var singleCheckboxBtnViewModels = [SingleCheckboxBtnViewModel]()
    
    private var checkboxBtnViewModelAttachedToText: SingleCheckboxBtnViewModel {
        return singleCheckboxBtnViewModels.last!
    }
    
    private var textView: UITextView {
        return view.locateClosestChild(ofType: UITextView.self)!
    }
    
    func getView() -> UIView {
        return self.view
    }
    func getActualAnswer() -> MyAnswer? { // single selection - not tested !!

        let questionOptions = question.options

        let selectedViewModels = singleCheckboxBtnViewModels.filter {$0.isOn}
        let selectedTags = selectedViewModels.map {$0.getView().tag}
        var content = selectedTags.map {questionOptions[$0]}
        
        if checkboxBtnViewModelAttachedToText.isOn && textView.text != question.description {
            content.append(textView.text)
        } else {
            let questionOptions = question.options // zasto ovde isto ? proveri? hard-coded
            content.removeAll(where: {!questionOptions.contains($0)})
        }

        if answer != nil {
            answer!.content = content
            answer!.optionIds = selectedTags
        } else {
            answer = MyAnswer(question: question, code: code, content: content, optionIds: selectedTags)
        }
        return answer
    }
    
    init(questionInfo: PresentQuestionInfoProtocol,
         checkboxBtnsWithInputViewFactory: CheckboxWithInputViewFactory) {
        
        self.question = questionInfo.getQuestion()
        self.answer = questionInfo.getAnswer()
        self.code = questionInfo.getCode()
        
        super.init()
        
        self.singleCheckboxBtnViewModels = checkboxBtnsWithInputViewFactory.getViewModels()
        self.view = checkboxBtnsWithInputViewFactory.getView()
        
        _ = self.view.findViews(subclassOf: UITextView.self).map {$0.delegate = self}
        _ = self.view.findViews(subclassOf: UIButton.self).map {
            $0.addTarget(self, action: #selector(CheckboxBtnsViewModel.btnTapped), for: .touchUpInside)
        }
        
    }

}

extension CheckboxInputViewModel: BtnTapListening {
    
    @objc func btnTapped(_ sender: UIButton) {
        
        toggleSelectedCheckboxBtn(sender: sender)
        
        if isSelectedCheckboxBtnAttachedToTextView(sender: sender) {
            manageTextViewIfAttachedCheckmarkIsTapped(sender: sender)
        } else {
            setTextViewUnfocused()
        }
    }
    
    private func toggleSelectedCheckboxBtn(sender: UIButton) {
        singleCheckboxBtnViewModels[sender.tag].isOn = !singleCheckboxBtnViewModels[sender.tag].isOn
    }
    
    private func isSelectedCheckboxBtnAttachedToTextView(sender: UIButton) -> Bool {
        return sender.tag == checkboxBtnViewModelAttachedToText.getView().tag
    }
    
    private func manageTextViewIfAttachedCheckmarkIsTapped(sender: UIButton) {
        if !checkboxBtnViewModelAttachedToText.isOn {
            textView.text = ""
            self.textView.resignFirstResponder()
        } else if !textView.isFirstResponder {
            delay(0.01) {
                self.textView.becomeFirstResponder()
            }
        }
    }
    
    private func setTextViewUnfocused() {
        textView.resignFirstResponder()
    }
    
}

extension CheckboxInputViewModel: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text != question.description { //print("setuj odg. btn, sve ostale reset")
            textView.textColor = .black
            checkboxBtnViewModelAttachedToText.isOn = true
        } else if textView.text == "" {
            _ = singleCheckboxBtnViewModels.map {$0.isOn = false}
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == question.description {
            textView.text = ""
        }
    }
}

