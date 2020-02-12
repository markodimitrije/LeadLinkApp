//
//  MovingKeyboardDelegate.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

class MovingKeyboardDelegate {
    
    var keyboardChangeHandler: (_ verticalShift: CGFloat) -> ()
    var keyboardActive = BehaviorSubject<Bool>.init(value: false)
    let disposeBag = DisposeBag()
    
    init(keyboardChangeHandler: @escaping (_ verticalShift: CGFloat) -> ()) {
        self.keyboardChangeHandler = keyboardChangeHandler
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MovingKeyboardDelegate.keyboardChange(_:)),
                                               name: UIApplication.keyboardWillShowNotification,// didshow ?
            object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MovingKeyboardDelegate.keyboardChange(_:)),
                                               name: UIApplication.keyboardWillHideNotification,// didshow ?
            object: nil)
    }
    
    @objc func keyboardChange(_ notification: NSNotification) {
        //print("keyboard shows, notification = \(notification)")
        let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        let shift = (notification.name == UIApplication.keyboardWillShowNotification) ? (-keyboardSize.height/2) : (keyboardSize.height/2)
        keyboardChangeHandler(shift)
        keyboardActive.onNext(notification.name == UIApplication.keyboardWillShowNotification)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillShowNotification, object: nil)
    }
    
}

class QuestionsAnswersMovingKeyboardDelegate {
    
    var keyboardChangeHandler: (_ verticalShift: CGFloat) -> ()
    var keyboardActive = BehaviorSubject<Bool>.init(value: false)
    let disposeBag = DisposeBag()
    
    init(keyboardChangeHandler: @escaping (_ verticalShift: CGFloat) -> ()) {
        self.keyboardChangeHandler = keyboardChangeHandler
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MovingKeyboardDelegate.keyboardChange(_:)),
                                               name: UIApplication.keyboardWillShowNotification,// didshow ?
            object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MovingKeyboardDelegate.keyboardChange(_:)),
                                               name: UIApplication.keyboardWillHideNotification,// didshow ?
            object: nil)
    }
    
    @objc func keyboardChange(_ notification: NSNotification) {
        //print("keyboard shows, notification = \(notification)")
        let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        let shift = (notification.name == UIApplication.keyboardWillShowNotification) ? (-keyboardSize.height/2) : (keyboardSize.height/2)
        keyboardChangeHandler(shift)
        keyboardActive.onNext(notification.name == UIApplication.keyboardWillShowNotification)
    }
    
}
