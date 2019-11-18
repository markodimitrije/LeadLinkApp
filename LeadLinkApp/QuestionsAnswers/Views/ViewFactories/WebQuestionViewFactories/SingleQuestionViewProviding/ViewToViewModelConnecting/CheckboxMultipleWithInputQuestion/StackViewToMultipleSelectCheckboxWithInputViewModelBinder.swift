//
//  StackViewToMultipleSelectCheckboxWithInputViewModelBinder.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 26/09/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class StackViewToMultipleSelectCheckboxWithInputViewModelBinder: ViewStackerViewsToViewModelBinder {
    
    func hookUp(btnViews: [UIView], viewmodel: CheckboxMultipleWithInputViewModel, bag: DisposeBag, selector: Selector? = nil) {
        
        var allViews = btnViews
        guard let txtField = allViews.popLast() as? UITextField else {return}
        var checkBtnViews: [CheckboxView] { return allViews as? [CheckboxView] ?? [ ] }
        
        var buttons: [UIButton] { return checkBtnViews.compactMap { $0.radioBtn } }
        
        let inputCreator = CheckboxMultipleWithInputViewmodelCreator.init(viewmodel: viewmodel, checkboxBtnViews: checkBtnViews)
        
        let textDrivers = inputCreator.textDrivers
        
        displayTextOnCheckboxesAndTextField(textDrivers: textDrivers, checkBtnViews: checkBtnViews, textField: txtField, bag: bag)
        
        handleTextChangeOnCheckboxesAndTextField(textDrivers: textDrivers, allViews: btnViews, bag: bag)
        
        let initial = viewmodel.answer?.optionIds ?? [ ]
        let checkboxTagState = BehaviorRelay<[Int]>.init(value: initial)
        let checkboxTagSequence = inputCreator.checkboxBtnsInput
        
        let obOptionTxt = txtField.rx.text.asObservable() // OK
        
        let input = CheckboxMultipleWithInputViewModel.Input.init(ids: checkboxTagState.asObservable(), optionTxt: obOptionTxt, answer: viewmodel.answer)
        
        let output = viewmodel.transform(input: input) // vratio sam identican input na output
        
        self.bindUiChangesToViewmodel(output: output, viewmodel: viewmodel, bag: bag)
        
        self.displayCheckboxesInitialy(output: output, checkBtnViews: checkBtnViews, bag: bag)
        
        self.handleCheckboxSelectDeselectBehaviour(checkboxTagSequence: checkboxTagSequence, checkboxTagState: checkboxTagState, bag: bag)
        
//        self.handleHowLastCheckboxTapInfluenceTextField(checkboxTapSequence: checkboxTagSequence, checkBtnViews: checkBtnViews, txtField: txtField, bag: bag)
        
//        self.handleHowTextFieldInfluenceLastCheckbox(textDriver: txtField.rx.text.asDriver(), checkBtnViews: checkBtnViews, bag: bag)
        
        self.loadInitialValuesFromExistingAnswerIfNonTextOption(viewmodel: viewmodel, checkboxViews: checkBtnViews)
        
    }
    
    private func displayTextOnCheckboxesAndTextField(textDrivers: [Driver<String>], checkBtnViews: [CheckboxView], textField: UITextField, bag: DisposeBag) {
        
        _ = textDrivers.enumerated().map { (offset, textDriver) in
            if offset == textDrivers.count-1 {
                textDriver.drive(textField.rx.text).disposed(by: bag)
            } else {
                textDriver.drive(checkBtnViews[offset].rx.optionTxt).disposed(by: bag)
            }
        }
    }
     // da li ovo radi to kako se ZOVE ??!?
    private func handleTextChangeOnCheckboxesAndTextField(textDrivers: [Driver<String>], allViews: [UIView], bag: DisposeBag) {
        
        _ = textDrivers.enumerated().map { (offset, textDriver) in
            guard let observer = (allViews[offset] as? OptionTxtUpdatable)?.optionTxt else {
                fatalError("nisam prosao offset za StackViewToCheckboxBtnsWithInputViewModelBinder")
            }
            
            textDriver
                .drive(observer)
                .disposed(by: bag)
            
            textDrivers.last?.asObservable()
                .subscribe(onNext: { (val) in
                    if val == "" {
                        //(allViews.last as? UITextField)?.placeholder = "Type your answer"
                        (allViews.last as? UITextField)?.placeholder = "Autre"
                    }
                })
                .disposed(by: bag)
        }
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
    
    private func bindUiChangesToViewmodel(output: CheckboxMultipleWithInputViewModel.Output,
                                          viewmodel: CheckboxMultipleWithInputViewModel,
                                          bag: DisposeBag) {
        
        let options = viewmodel.question.options
        // source signals:
        let checkboxContent = output.ids.flatMap { indexes -> Observable<[String]> in
            return Observable.create({ observer -> Disposable in
                var content = [String]()
                for index in indexes {
                    content.append(options[index])
                }
                observer.onNext(content)
                return Disposables.create()
            })
        }
        let txtFieldContent = output.optionTxt.map {[$0!]}.asObservable()
        // composite signal:
        let composite: Observable<[String]> = Observable.combineLatest(checkboxContent, txtFieldContent) {
            (checkboxTexts, txtFieldText) -> [String] in
                checkboxTexts + txtFieldText
        }
        // hook signal to listener
        composite
            .bind(to: viewmodel.rx.newContent)
            .disposed(by: bag)
        
    }
    
    private func displayCheckboxesInitialy(output: CheckboxMultipleWithInputViewModel.Output,
                                           checkBtnViews: [CheckboxView],
                                           bag: DisposeBag) {
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
    }
    
    private func handleCheckboxSelectDeselectBehaviour(checkboxTagSequence: Observable<Int>,
                                                       checkboxTagState: BehaviorRelay<[Int]>,
                                                       bag: DisposeBag) {
        checkboxTagSequence.subscribe(onNext: { tag in
            var arr = checkboxTagState.value
            if let i = checkboxTagState.value.firstIndex(of: tag) { // vec je u nizu...
                arr.remove(at: i)
                checkboxTagState.accept(arr)
            } else {
                arr.append(tag)
                checkboxTagState.accept(arr)
            }
        }).disposed(by: bag)
    }
    
    // ispitaj da li je poslednji checkbox, i ako da -> ili activate txtField ili ga clear+deactivate
    private func handleHowLastCheckboxTapInfluenceTextField(checkboxTapSequence: Observable<Int>, checkBtnViews: [CheckboxView], txtField: UITextField, bag: DisposeBag) {
        
        checkboxTapSequence
            .subscribe(onNext: { val in

                if val == checkBtnViews.count - 1 { print("tapnuo je other checkbox!!!")
                    if checkBtnViews[val].isOn {
                        txtField.becomeFirstResponder()
                    } else {
                        txtField.text = ""
                        txtField.resignFirstResponder()
                    }
                } else {
                    print("tap si index = \(val)")
                }
            }).disposed(by: bag)
    }
    
    private func handleHowTextFieldInfluenceLastCheckbox(textDriver: Driver<String?>, checkBtnViews: [CheckboxView], bag: DisposeBag) {
        
        textDriver.asObservable()
            .subscribe(onNext: { text in
                
                checkBtnViews.last?.isOn = true
                
            }).disposed(by: bag)
    }
    
}
