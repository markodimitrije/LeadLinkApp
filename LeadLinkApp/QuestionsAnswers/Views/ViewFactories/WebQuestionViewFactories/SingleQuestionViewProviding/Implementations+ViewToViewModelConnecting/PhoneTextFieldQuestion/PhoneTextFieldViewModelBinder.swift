//
//  PhoneTextFieldViewModelBinder.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 06/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

protocol PhoneTextFieldReleaseDelegateProtocol {
    func phoneTextFieldReleased(value: String)
}

class PhoneTextFieldViewModelBinder: NSObject, UITextFieldDelegate {
    
    private var labelAndTextView: LabelAndPhoneTxtField!
    private var viewmodel: LabelWithPhoneTextFieldViewModel!
    private var bag: DisposeBag!
    
    func hookUp(labelAndTextView: LabelAndPhoneTxtField, viewmodel: LabelWithPhoneTextFieldViewModel, bag: DisposeBag) {
        
        self.labelAndTextView = labelAndTextView
        self.viewmodel = viewmodel
        self.bag = bag
        
        let inputCreator = LabelAndPhoneTextFieldFromModelInputCreator(viewmodel: viewmodel)
        let driver = inputCreator.createTxtDriver()
        
        driver
            .bind(to: labelAndTextView.rx.titles)
            .disposed(by: bag)
        
        labelAndTextView.textField.rx.text.asObservable()
            .bind(to: viewmodel.rx.answer)
            .disposed(by: bag)
        
        self.formatPhoneTextField()
        
    }
    
    private func formatPhoneTextField() {
        labelAndTextView.textField.keyboardType = .phonePad
    }

}
