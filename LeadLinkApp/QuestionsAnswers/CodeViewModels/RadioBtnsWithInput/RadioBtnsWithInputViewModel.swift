//
//  RadioBtnsWithInputViewModel.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 11/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class RadioBtnsWithInputViewModel: NSObject, QuestionPageViewModelProtocol {
    
    private var question: PresentQuestion
    private var answer: MyAnswer?
    private var code: String = ""
    
    private var view: UIView!
    private var singleRadioBtnViewModels = [SingleRadioBtnViewModel]()
    
    private var radioBtnViewModelAttachedToText: SingleRadioBtnViewModel {
        return singleRadioBtnViewModels.last!
    }
    private var nonTextRadioBtnViewModels: [SingleRadioBtnViewModel] {
        return singleRadioBtnViewModels.dropLast()
    }
    fileprivate var textView: UITextView {
        return view.locateClosestChild(ofType: UITextView.self)!
    }
    
    func getView() -> UIView {
        return self.view
    }
    func getActualAnswer() -> MyAnswer? { // single selection - not tested !!

        let questionOptions = question.options

        let selectedViewModels = singleRadioBtnViewModels.filter {$0.isOn}
        let selectedTags = selectedViewModels.map {$0.getView().tag}
        var content = selectedTags.map {questionOptions[$0]}
        
        if radioBtnViewModelAttachedToText.isOn && textView.text != question.description {
            content.append(textView.text)
        } else {
            let questionOptions = question.options
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
    
    init(questionInfo: PresentQuestionInfoProtocol, radioBtnsWithInputViewFactory: RadioBtnsWithInput_ViewFactory) {
        
        self.question = questionInfo.getQuestion()
        self.answer = questionInfo.getAnswer()
        self.code = questionInfo.getCode()
        
        super.init()
        
        self.singleRadioBtnViewModels = radioBtnsWithInputViewFactory.getViewModels()
        self.view = radioBtnsWithInputViewFactory.getView()
        self.view.tag = questionInfo.getQuestion().id
        
        _ = self.view.findViews(subclassOf: UITextView.self).map {$0.delegate = self}
        _ = self.view.findViews(subclassOf: UIButton.self).map {
            $0.addTarget(self, action: #selector(RadioBtnsViewModel.btnTapped), for: .touchUpInside)
        }
        
    }
    
}

extension RadioBtnsWithInputViewModel: BtnTapListening {
    
    @objc func btnTapped(_ sender: UIButton) {
        setSelectedRadioBtnAndClearOthers(sender: sender)
        setTextViewTextToPlaceholderText()
        setTextViewUnfocused()
        
        if isSelectedRadioBtnAttachedToTextView(sender: sender) {
            textView.becomeFirstResponder()
        } else {
            setTextViewUnfocused()
        }
        
    }
    
    private func isSelectedRadioBtnAttachedToTextView(sender: UIButton) -> Bool {
        return sender.tag == radioBtnViewModelAttachedToText.getView().tag
    }
    
    private func setSelectedRadioBtnAndClearOthers(sender: UIButton) {
        singleRadioBtnViewModels[sender.tag].isOn = !singleRadioBtnViewModels[sender.tag].isOn
        //print("sve ostale setuj na false")
        let toDisable = singleRadioBtnViewModels.filter {$0.getView().tag != sender.tag}
        _ = toDisable.map {$0.isOn = false}
    }
    
    private func setTextViewTextToPlaceholderText() {
        textView.text = question.description
        textView.textColor = .lightGray
    }
    
    private func setTextViewUnfocused() {
        textView.resignFirstResponder()
    }
    
}

extension RadioBtnsWithInputViewModel: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text != question.description { //print("setuj odg. btn, sve ostale reset")
            textView.textColor = .black
            radioBtnViewModelAttachedToText.isOn = true
            _ = nonTextRadioBtnViewModels.map {$0.isOn = false}
        } else if textView.text == "" {
            _ = singleRadioBtnViewModels.map {$0.isOn = false}
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == question.description {
            textView.text = ""
        }
    }
}
