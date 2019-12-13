//
//  ScrollViewKeyboardHandler.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 13/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class ScrollViewKeyboardHandler: KeyboardHandling {
    internal var scrollView: UIScrollView
    init(scrollView: UIScrollView) {
        self.scrollView = scrollView
    }
    
    func registerForKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
       if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let textView = scrollView.findViews(subclassOf: UITextView.self).first(where: {$0.isFirstResponder})
            let textField = scrollView.findViews(subclassOf: UITextField.self).first(where: {$0.isFirstResponder})
            let possibleResponder = textView ?? textField
            
            if let responder = possibleResponder {
                    
                let relativeOrigin = responder.convert(responder.frame.origin, to: scrollView)
                
                // scroll up by keyboardHeight, but only if responder wont leave the screen
                if relativeOrigin.y - keyboardSize.height > scrollView.contentOffset.y {
                    scrollView.contentOffset.y = scrollView.contentOffset.y + keyboardSize.height
                }
            }
        }
   }
}
