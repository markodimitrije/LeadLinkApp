//
//  StackViewToCheckboxBtnsWithInputViewModelBinder.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 06/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class StackViewToCheckboxBtnsWithInputViewModelBinder: ViewStackerViewsToViewModelBinder {
    
    func hookUp(btnViews: [UIView], viewmodel: CheckboxWithInputViewModel, bag: DisposeBag, selector: Selector? = nil) {
        
        var allViews = btnViews
        guard let txtField = allViews.popLast() as? UITextField else {return}
        var radioBtnViews: [CheckboxView] { return allViews as? [CheckboxView] ?? [ ] }
        
        var buttons: [UIButton] { return radioBtnViews.compactMap { $0.radioBtn } }
        
        let inputCreator = CheckboxWithInputViewmodelCreator.init(viewmodel: viewmodel, checkboxBtnViews: radioBtnViews)
        
        let textDrivers = inputCreator.textDrivers
        let values = inputCreator.checkboxBtnsInput
        
        _ = textDrivers.enumerated().map { (offset, textDriver) in
            
            guard let observer = (btnViews[offset] as? OptionTxtUpdatable)?.optionTxt else {
                fatalError("nisam prosao offset za StackViewToCheckboxBtnsWithInputViewModelBinder")
                //return
            }
            
            textDriver
                .drive(observer)
                .disposed(by: bag)
            
            textDrivers.last?.asObservable()
                .subscribe(onNext: { (val) in
                    if val == "" {
                        (btnViews.last as? UITextField)?.placeholder = "Type your answer"
                    }
                })
                .disposed(by: bag)
        }
        
        let obOptionTxt = txtField.rx.text.asObservable() // OK
        
        let input = CheckboxWithInputViewModel.Input.init(ids: values, optionTxt: obOptionTxt, answer: viewmodel.answer)
        
        let output = viewmodel.transform(input: input) // vratio sam identican input na output
        
        // bind to viewmodel
        output.ids
            .bind(to: viewmodel.rx.optionSelected)
            .disposed(by: bag)
        
        output.optionTxt.filter {$0 != ""}.map {$0!}
            .bind(to: viewmodel.rx.txtChanged)
            .disposed(by: bag)
        
        // drive UI
        
        output.ids.subscribe(onNext: { val in
            let active = buttons.first(where: { $0.tag == val })
            var inactive = buttons
            inactive.remove(at: val) // jer znam da su indexed redom..
            _ = inactive.map {
                radioBtnViews[$0.tag].isOn = false
            }
            _ = active.map {
                if $0.tag < radioBtnViews.count-1 {
                    txtField.text = ""
                    txtField.resignFirstResponder()
                    
                } else {
                    txtField.becomeFirstResponder()
                }
                radioBtnViews[$0.tag].isOn = true
            }
        }).disposed(by: bag)
        
        output.optionTxt.subscribe(onNext: { val in
            if val != "" {
                if let answer = viewmodel.answer, answer.optionIds?.last == radioBtnViews.last?.radioBtn.tag {
                    _ = radioBtnViews.map {$0.isOn = false}
                }
                _ = radioBtnViews.map {$0.isOn = false}
                radioBtnViews.last?.isOn = true // we want other option to be selected
            }
        }).disposed(by: bag)
        
        self.loadInitialValuesFromExistingAnswerIfNonTextOption(viewmodel: viewmodel, checkboxViews: radioBtnViews)
        
    }
    
    private func loadInitialValuesFromExistingAnswerIfNonTextOption(viewmodel: CheckboxWithInputViewModel,
                                                                    checkboxViews: [CheckboxView]) {
        guard let answer = viewmodel.answer, let content = answer.content.first else {return}
        let questionOptions = viewmodel.question.options
        let answerIsNotTxtOption = questionOptions.contains(content)
        if answerIsNotTxtOption {
            if let index = questionOptions.firstIndex(of: answer.content.first!) {
                checkboxViews[index].isOn = true
            }
        }
    }
    
}
