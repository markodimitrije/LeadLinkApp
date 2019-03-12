//
//  ScanningVC.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class ScanningVC: UIViewController {

    @IBOutlet weak var contentViewToTopSafeAreaConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewToBottomSafeAreaConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var barCodeTxtField: UITextField!
    
    var campaignId: Int? // ako ti neko dobaci ovo, mozes da izvuces campaign (Logo, questions, answers....) (iz dataProvider-a)
    var keyboardManager: MovingKeyboardDelegate?
    
    override func viewDidLoad() { super.viewDidLoad()
        
        barCodeTxtField.delegate = self
        
        keyboardManager = MovingKeyboardDelegate.init(keyboardChangeHandler: { (halfKeyboardHeight) in
            
            self.contentViewToTopSafeAreaConstraint!.constant += 2*halfKeyboardHeight
            self.contentViewToBottomSafeAreaConstraint!.constant -= 2*halfKeyboardHeight
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        })
        
    }
    
}

extension ScanningVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print("barCodeTxtField = \(barCodeTxtField.text)")
        return true
    }
}
