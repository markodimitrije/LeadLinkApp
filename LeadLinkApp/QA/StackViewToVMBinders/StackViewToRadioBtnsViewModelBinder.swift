//
//  StackViewToRadioBtnsViewModelBinder.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 06/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class StackViewToRadioBtnsViewModelBinder: StackViewToViewModelBinder {
    
    func hookUp(view: ViewStacker, btnViews: [RadioBtnView], viewmodel: RadioViewModel, bag: DisposeBag) {
        
        let inputCreator = RadioViewmodelInputCreator(viewmodel: viewmodel)
        
        let buttons = btnViews.compactMap {$0.radioBtn}
        
        let textDrivers = inputCreator.createTxtDrivers()
        
        _ = textDrivers.enumerated().map { (offset, textDriver) in
            textDriver.drive(btnViews[offset].rx.optionTxt)
        }
        
        let values = inputCreator.createRadioBtnsInput(btnViews: btnViews)
        
        let input = RadioViewModel.Input.init(ids: values, answer: viewmodel.answer)
        
        let output = viewmodel.transform(input: input) // vratio sam identican input na output
        
        output.ids
            .bind(to: viewmodel.rx.optionSelected)
            .disposed(by: bag)
        
        // ovo radi... ali nije PRAVI Reactive !
        output.ids.subscribe(onNext: { val in
            let active = buttons.first(where: { $0.tag == val })
            var inactive = buttons
            inactive.remove(at: val) // jer znam da su indexed redom..
            _ = inactive.map({
                btnViews[$0.tag].isOn = false
            })
            _ = active.map({
                btnViews[$0.tag].isOn = true
            })
        }).disposed(by: bag)
    }
}
