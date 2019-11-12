//
//  MovingKeyboardDelegateFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class MovingKeyboardDelegateFactory {
    
    func create(handler: @escaping (_ verticalShift: CGFloat) -> ()) -> MovingKeyboardDelegate {
        
        return MovingKeyboardDelegate.init(keyboardChangeHandler: { (halfKeyboardHeight) in
            var verticalShift: CGFloat = 0
            if UIDevice.current.userInterfaceIdiom == .phone {
                verticalShift = 2*halfKeyboardHeight
            } else if UIDevice.current.userInterfaceIdiom == .pad {
                verticalShift = halfKeyboardHeight
            }
            handler(verticalShift)
        })
    }
}
