//
//  StackViewToCheckboxBtnsViewModelBinder.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 06/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class StackViewToCheckboxBtnsViewModelBinder: StackViewToViewModelBinder {
    
    func hookUp(view: ViewStacker, btnViews: [CheckboxView], viewmodel: CheckboxViewModel, bag: DisposeBag) {
        
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
