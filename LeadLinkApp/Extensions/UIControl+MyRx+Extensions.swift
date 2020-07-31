//
//  MyRxExtensions.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 26/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//
import UIKit
import RxCocoa
import RxSwift

protocol OptionTxtUpdatable {
    // trebalo bi napisati tako da namece uslov: (******)
    var optionTxt: Binder<String> {get}
}

// MARK:- RECEIVERS
extension UITextField: OptionTxtUpdatable {
    var optionTxt: Binder<String> {
        return self.rx.optionTxt
    }
}

extension Reactive where Base: UITextField {
    var optionTxt: Binder<String> {
        return Binder.init(self.base, binding: { (view, value) in
            view.text = value
        })
    }
}

// MARK:- EMITERS:
extension Reactive where Base: UISwitch {
    public var switchTag: ControlProperty<Int> {
        return base.rx.controlProperty(editingEvents: UIControl.Event.valueChanged, getter: { (uiSwitch) -> Int in
            uiSwitch.tag
        }, setter: { (uiSwitch, value) in
            uiSwitch.tag = value
        })
    }
}
