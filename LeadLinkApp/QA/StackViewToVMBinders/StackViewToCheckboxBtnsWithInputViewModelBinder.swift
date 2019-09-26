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


class StackViewToMultipleSelectCheckboxWithInputViewModelBinder: ViewStackerViewsToViewModelBinder {
    
    func hookUp(btnViews: [UIView], viewmodel: CheckboxMultipleWithInputViewModel, bag: DisposeBag, selector: Selector? = nil) {
        
        var allViews = btnViews
        guard let txtField = allViews.popLast() as? UITextField else {return}
        var checkBtnViews: [CheckboxView] { return allViews as? [CheckboxView] ?? [ ] }
        
        var buttons: [UIButton] { return checkBtnViews.compactMap { $0.radioBtn } }
        
        let inputCreator = CheckboxMultipleWithInputViewmodelCreator.init(viewmodel: viewmodel, checkboxBtnViews: checkBtnViews)
        
        let textDrivers = inputCreator.textDrivers
//        let btnDrivers = inputCreator.checkboxBtnsInput
        
        _ = textDrivers.enumerated().map { (offset, textDriver) in
            if offset == textDrivers.count-1 {
                textDriver.drive(txtField.rx.text).disposed(by: bag)
            } else {
                textDriver.drive(checkBtnViews[offset].rx.optionTxt).disposed(by: bag)
            }
        }
        
        let initial = viewmodel.answer?.optionIds ?? [ ]
        
        let checkedArr = BehaviorRelay<[Int]>.init(value: initial)
        let values = inputCreator.checkboxBtnsInput
        
        values.subscribe(onNext: { tag in
            var arr = checkedArr.value
            if let i = checkedArr.value.firstIndex(of: tag) { // vec je u nizu...
                arr.remove(at: i)
                checkedArr.accept(arr)
            } else {
                arr.append(tag)
                checkedArr.accept(arr)
            }
        }).disposed(by: bag)
        
        _ = textDrivers.enumerated().map { (offset, textDriver) in
            
            guard let observer = (btnViews[offset] as? OptionTxtUpdatable)?.optionTxt else {
                fatalError("nisam prosao offset za StackViewToCheckboxBtnsWithInputViewModelBinder")
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
        
        let input = CheckboxMultipleWithInputViewModel.Input.init(ids: checkedArr.asObservable(), optionTxt: obOptionTxt, answer: viewmodel.answer)
        
        let output = viewmodel.transform(input: input) // vratio sam identican input na output
        
        // bind to viewmodel
        output.ids
            .bind(to: viewmodel.rx.optionSelected)
            .disposed(by: bag)
        
        output.optionTxt.filter {$0 != ""}.map {$0!}
            .bind(to: viewmodel.rx.txtChanged)
            .disposed(by: bag)
        
        // drive UI

        // update UI
        output.ids
            .subscribe(onNext: { array in
                
                let active = checkBtnViews.filter { view -> Bool in
                    array.contains(view.radioBtn.tag)
                }
                
                _ = checkBtnViews.map({ btn in
                    let checked = active.contains(btn)
                    btn.isOn = checked
                })
                
            }).disposed(by: bag)
        
//        output.ids.subscribe(onNext: { val in
//            let active = buttons.first(where: { $0.tag == val })
//            var inactive = buttons
//            inactive.remove(at: val) // jer znam da su indexed redom..
//            _ = inactive.map {
//                checkBtnViews[$0.tag].isOn = false
//            }
//            _ = active.map {
//                if $0.tag < checkBtnViews.count-1 {
//                    txtField.text = ""
//                    txtField.resignFirstResponder()
//
//                } else {
//                    txtField.becomeFirstResponder()
//                }
//                checkBtnViews[$0.tag].isOn = true
//            }
//        }).disposed(by: bag)
        
        self.loadInitialValuesFromExistingAnswerIfNonTextOption(viewmodel: viewmodel, checkboxViews: checkBtnViews)
        
    }
    
    private func loadInitialValuesFromExistingAnswerIfNonTextOption(
        viewmodel: CheckboxMultipleWithInputViewModel,
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


class StackViewToCheckboxBtnsViewModelBinderTemplate: ViewStackerViewsToViewModelBinder {
    
    func hookUp(btnViews: [CheckboxView], viewmodel: CheckboxViewModel, bag: DisposeBag, selector: Selector? = nil) {
        
        let inputCreator = CheckboxViewmodelInputCreator(viewmodel: viewmodel)
        
        _ = inputCreator.createTxtDrivers().enumerated().map { (offset, textDriver) in
            textDriver.drive(btnViews[offset].rx.optionTxt)
        }
        
        let initial = viewmodel.answer?.optionIds ?? [ ]
        
        let checkedArr = BehaviorRelay<[Int]>.init(value: initial)
        
        let values = inputCreator.createCheckboxBtnsInput(btnViews: btnViews)
        
        values.subscribe(onNext: { tag in
            var arr = checkedArr.value
            if let i = checkedArr.value.firstIndex(of: tag) { // vec je u nizu...
                arr.remove(at: i)
                checkedArr.accept(arr)
            } else {
                arr.append(tag)
                checkedArr.accept(arr)
            }
        }).disposed(by: bag)
        
        let input = CheckboxViewModel.Input.init(ids: checkedArr.asObservable(), answer: viewmodel.answer)
        
        let output = viewmodel.transform(input: input) // vratio sam identican input na output
        
        // update UI
        output.ids
            .subscribe(onNext: { array in
                
                let active = btnViews.filter { view -> Bool in
                    array.contains(view.radioBtn.tag)
                }
                
                _ = btnViews.map({ btn in
                    let checked = active.contains(btn)
                    btn.isOn = checked
                })
                
            }).disposed(by: bag)
        
        // update model
        output.ids
            .bind(to: viewmodel.rx.optionSelected)
            .disposed(by: bag)
        
    }
    
}
