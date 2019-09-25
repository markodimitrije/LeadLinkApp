//
//  StackViewToTermsViewModelBinder.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 20/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class StackViewToTermsViewModelBinder: ViewStackerViewsToViewModelBinder {
    func hookUp(btnViews: [TermsLabelBtnSwitchView], viewmodel: SwitchBtnsViewModel, bag: DisposeBag, selector: Selector? = nil) {
        
        let inputCreator = TermsSwitchBtnsViewmodelInputCreator(viewmodel: viewmodel)
        
        _ = inputCreator.createTxtDrivers()
            .enumerated().map { (offset, textDriver) in
            switch offset {
                case 0: textDriver.drive(btnViews.first!.rx.labelTxt).disposed(by: bag)
                case 1: textDriver.drive(btnViews.first!.rx.linkBtnTxt).disposed(by: bag)
                case 2: textDriver.drive(btnViews.first!.rx.termsTxt).disposed(by: bag)
            default: break
            }
        }
        
        let initial = viewmodel.answer?.optionIds ?? [ ]
        
        let checkedArr = BehaviorRelay<[Int]>.init(value: initial) // mozda treba sa answer !!?
        
        let values = inputCreator.createSwitchBtnsInput(btnViews: btnViews)
        
        values
            .skip(btnViews.count) // what a hack....
            .subscribe(onNext: { tag in
                var arr = checkedArr.value
                if let i = checkedArr.value.firstIndex(of: tag) { // vec je u nizu...
                    arr.remove(at: i)
                    checkedArr.accept(arr)
                } else {
                    arr.append(tag)
                    checkedArr.accept(arr)
                }
            }).disposed(by: bag)
        
        let input = SwitchBtnsViewModel.Input.init(ids: checkedArr.asObservable(), answer: viewmodel.answer)
        
        let output = viewmodel.transform(input: input) // vratio sam identican input na output
        
        output.ids
            .bind(to: viewmodel.rx.optionSelected)
            .disposed(by: bag)
        
        // ovo radi... ali nije PRAVI Reactive !
        output.ids.subscribe(onNext: { array in
            
            let active = btnViews.filter { view -> Bool in
                array.contains(view.switcher.tag)
            }
            
            _ = btnViews.map({ btn in
                let checked = active.contains(btn)
                btn.switcher.isOn = checked
            })
            
        }).disposed(by: bag)
        
    }
}
