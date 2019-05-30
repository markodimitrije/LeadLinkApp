//
//  TextFieldViewModelBinder.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 06/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// regular textField...
class TextFieldToViewModelBinder {
    
    private var view: ViewStacker!
    private var labelAndTextView: LabelAndTextField!
    private var viewmodel: LabelWithTextFieldViewModel!
    private var bag: DisposeBag!
    
    private var isBarcodeTxtField: Bool { return viewmodel.question.options.contains("barcode") }
    private var isEmailTxtField: Bool { return viewmodel.question.options.contains("email") }
    
    func hookUp(view: ViewStacker, labelAndTextView: LabelAndTextField, viewmodel: LabelWithTextFieldViewModel, bag: DisposeBag) {
        
        self.view = view
        self.labelAndTextView = labelAndTextView
        self.viewmodel = viewmodel
        self.bag = bag
        
        let inputCreator = LabelAndTextFieldFromModelInputCreator(viewmodel: viewmodel)
        let driver = isBarcodeTxtField ? inputCreator.createBarcodeTxtDriver(): inputCreator.createTxtDriver()
        
        driver
            .bind(to: labelAndTextView.rx.titles)
            .disposed(by: bag)
        
        labelAndTextView.textField.rx.text.asObservable()
            .bind(to: viewmodel.rx.answer)
            .disposed(by: bag)
        
        checkForBarcodeAndEmailFields()
        
    }
    
    private func checkForBarcodeAndEmailFields() {
        if isBarcodeTxtField {
            self.formatBarcodeTextField()
        } else if isEmailTxtField {
            self.formatEmailTextField()
        }
    }
    
    private func formatBarcodeTextField() {
        labelAndTextView.textField.isEnabled = false
        labelAndTextView.textField.textColor = UIColor.barcodeTxtGray
        labelAndTextView.textField.backgroundColor = UIColor.barcodeBackground
        labelAndTextView.textField.font = UIFont.systemFont(ofSize: 22)
    }
    
    private func formatEmailTextField() {
        labelAndTextView.textField.keyboardType = .emailAddress
    }
}

