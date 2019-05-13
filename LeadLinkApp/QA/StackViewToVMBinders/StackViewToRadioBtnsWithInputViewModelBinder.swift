//
//  StackViewToRadioBtnsWithInputViewModelBinder.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 06/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class StackViewToRadioBtnsWithInputViewModelBinder: StackViewToViewModelBinder {
    
    private var view: ViewStacker!
    private var btnViews: [UIView]!
    private var viewmodel: RadioWithInputViewModel!
    private var bag: DisposeBag!
    
    private var radioBtnViews = [RadioBtnView]()
    private var txtField: UITextField!
    private var buttons: [UIButton] { return self.radioBtnViews.compactMap { $0.radioBtn } }
    
    private var textDrivers: [Driver<String>]!
    private var output: RadioWithInputViewModel.Output!
    private var obOptionTxt: Observable<String?>!
    
    func hookUp(view: ViewStacker, btnViews: [UIView], viewmodel: RadioWithInputViewModel, bag: DisposeBag) {
        
        self.view = view
        self.btnViews = btnViews
        self.viewmodel = viewmodel
        self.bag = bag
        
        var allViews = btnViews
        guard let txtField = allViews.popLast() as? UITextField else {return}
        
        self.radioBtnViews = allViews as? [RadioBtnView] ?? [ ]
        self.txtField = txtField
        
        let inputCreator = RadioWithInputViewmodelInputCreator.init(viewmodel: viewmodel, radioBtnViews: radioBtnViews)
        
        self.textDrivers = inputCreator.textDrivers
        
        //let obOptionTxt = Observable.from([txtField.text!]) GRESKA !
        self.obOptionTxt = txtField.rx.text.asObservable() // OK
        
        let input = RadioWithInputViewModel.Input.init(id: inputCreator.radioBtnsInput, optionTxt: obOptionTxt, answer: viewmodel.answer)
        
        output = viewmodel.transform(input: input) // vratio sam identican input na output
        
        loadTextOnRadioBtnsAndTextFieldView()
        
        loadInitialValuesFromExistingAnswerIfAnswerIsNonTextOption()

        updateAllUIControlsDueToRadioBtnSelection()

        userIsTypingManageRadioBtnSelection()

        updateAnswerInViewModels()
    }
    
    private func userIsTypingManageRadioBtnSelection() {
        
        output.optionTxt
            .subscribe(onNext: { [weak self] val in
                guard let sSelf = self else {return}
                if val != "" {
                    if let answer = sSelf.viewmodel.answer, answer.optionIds?.last == sSelf.radioBtnViews.last?.radioBtn.tag {
                        _ = sSelf.radioBtnViews.map {$0.isOn = false}
                    }
                    _ = sSelf.radioBtnViews.map {$0.isOn = false}
                    sSelf.radioBtnViews.last?.isOn = true // we want other option to be selected
                }
            }).disposed(by: bag)
    }
    
    private func loadTextOnRadioBtnsAndTextFieldView() {
        _ = textDrivers.enumerated().map { (offset, textDriver) in
            
            guard let observer = (btnViews[offset] as? OptionTxtUpdatable)?.optionTxt else {
                print("nisam prosao za offset = \(offset)")
                return
            }
            
            textDriver
                .drive(observer)
                .disposed(by: bag)
            
            textDrivers.last?.asObservable()
                .subscribe(onNext: { [weak self] (val) in
                    guard let sSelf = self else {return}
                    if val == "" {
                        sSelf.txtField.placeholder = "Type your text here"
                    }
                })
                .disposed(by: bag)
        }
    }
    
    private func updateAllUIControlsDueToRadioBtnSelection() {
        // drive UI
         output.id
            .subscribe(onNext: { [weak self] val in
                guard let sSelf = self else {return}
                let active = sSelf.buttons.first(where: { $0.tag == val })
                var inactive = sSelf.buttons
                inactive.remove(at: val) // jer znam da su indexed redom..
                _ = inactive.map {
                    sSelf.radioBtnViews[$0.tag].isOn = false
                }
                _ = active.map {
                    if $0.tag < sSelf.radioBtnViews.count-1 {
                        sSelf.txtField.text = ""
                        sSelf.txtField.resignFirstResponder()
                        
                    } else {
                        sSelf.txtField.becomeFirstResponder()
                    }
                    sSelf.radioBtnViews[$0.tag].isOn = true
                }
            }).disposed(by: bag)
    }
    
    private func loadInitialValuesFromExistingAnswerIfAnswerIsNonTextOption() {
        guard let answer = viewmodel.answer else {return}
        let questionOptions = viewmodel.question.options
        let answerIsNotTxtOption = questionOptions.contains(answer.content.first!)
        if answerIsNotTxtOption {
            if let index = questionOptions.index(of: answer.content.first!) {
                radioBtnViews[index].isOn = true
            }
        }
    }

    private func updateAnswerInViewModels() { // bind to viewmodel, to update MODEL
        
        output.id
            .bind(to: viewmodel.rx.optionSelected)
            .disposed(by: self.bag)
        
        output.optionTxt.filter {$0 != ""}.map {$0!}
            .bind(to: viewmodel.rx.txtChanged)
            .disposed(by: self.bag)
    }
    
}
