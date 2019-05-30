//
//  StackViewToTextAreaBinder.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 29/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TextAreaViewModelBinder {
    
    func hookUp(view: ViewStacker, labelAndTextView: LabelAndTextView, viewmodel: LabelWithTextFieldViewModel, bag: DisposeBag) {
        
        let inputCreator = LabelAndTextFieldFromModelInputCreator(viewmodel: viewmodel)
        let driver = inputCreator.createTxtDriver()
        
        driver
            .bind(to: labelAndTextView.rx.texts)
            .disposed(by: bag)
        
          labelAndTextView.textView.rx.text.asObservable()
            .bind(to: viewmodel.rx.answer)
            .disposed(by: bag)
    }
    
//    func copyHookUp(view: ViewStacker, labelAndTextView: LabelAndTextField, viewmodel: LabelWithTextFieldViewModel, bag: DisposeBag) {
//
//        let inputCreator = LabelAndTextFieldFromModelInputCreator(viewmodel: viewmodel)
//        let driver = inputCreator.createTxtDriver()
//
//        driver
//            .bind(to: labelAndTextView.rx.titles)
//            .disposed(by: bag)
//
//        labelAndTextView.textField.rx.text.asObservable()
//            .bind(to: viewmodel.rx.answer)
//            .disposed(by: bag)
//
//    }
    
    
    
}