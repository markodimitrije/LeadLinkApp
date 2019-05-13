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
    
    func hookUp(view: ViewStacker, labelAndTextView: LabelAndTextField, viewmodel: LabelWithTextFieldViewModel, bag: DisposeBag) {
        
        let inputCreator = LabelAndTextFieldFromModelInputCreator(viewmodel: viewmodel)
        let driver = inputCreator.createTxtDriver()
        
        driver
            .bind(to: labelAndTextView.rx.titles)
            .disposed(by: bag)
        
        labelAndTextView.textField.rx.text.asObservable()
            .bind(to: viewmodel.rx.answer)
            .disposed(by: bag)
        
    }
    
}
