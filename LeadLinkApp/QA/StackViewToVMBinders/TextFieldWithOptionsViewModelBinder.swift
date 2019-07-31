//
//  TextFieldWithOptionsViewModelBinder.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 06/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// your inputs is content: [String]
class TextViewToDropdownViewModelBinder {
    
    private var labelAndTextView: LabelAndTextView!
    private var viewmodel: SelectOptionTextFieldViewModel!
    private var bag: DisposeBag!
    
    func hookUp(labelAndTextView: LabelAndTextView, viewmodel: SelectOptionTextFieldViewModel, bag: DisposeBag) {
        
        self.labelAndTextView = labelAndTextView
        self.viewmodel = viewmodel
        self.bag = bag
        
        let inputCreator = SelectOptionTextViewModelInputCreator(viewmodel: viewmodel)
        let textDriver = inputCreator.createTxtDriver()
        
        textDriver
            .map {[$0.headline, $0.displayText, $0.placeholderText]}
            .bind(to: labelAndTextView.rx.texts)
            .disposed(by: bag)
        
        let content = textDriver.map {$0.textOptions}
        
        let input = SelectOptionTextFieldViewModel.Input.init(content: content, answer: viewmodel.answer)
        let output = viewmodel.transform(input: input) // vratio sam identican input na output
        
        // update model over viewmodel -> fill database with source signal (output.content)
        output.content
            .bind(to: viewmodel.rx.optionsSelected)
            .disposed(by: bag)

    }
}
