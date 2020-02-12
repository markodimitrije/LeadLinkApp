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
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let textView = scrollView.findViews(subclassOf: UITextView.self).first(where: {$0.isFirstResponder})
        let textField = scrollView.findViews(subclassOf: UITextField.self).first(where: {$0.isFirstResponder})
        let possibleResponder = textView ?? textField
        
        guard let responder = possibleResponder else {
            return
        }
                
        var relativeOrigin = responder.convert(responder.frame.origin, to: scrollView)
        relativeOrigin.y += responder.bounds.height
        
        if willFirstResponderBeCoveredWithKeyboard(relativeOrigin: relativeOrigin,
                                                   keyboardHeight: keyboardSize.height) {
            
            scrollView.contentOffset.y = scrollView.contentOffset.y + keyboardSize.height
        }
    }
    
    private func willFirstResponderBeCoveredWithKeyboard(relativeOrigin: CGPoint, keyboardHeight: CGFloat) -> Bool {
        let keyboardTopY = scrollView.contentOffset.y + (UIScreen.main.bounds.height) - keyboardHeight
        return relativeOrigin.y > keyboardTopY
    }
    
}
