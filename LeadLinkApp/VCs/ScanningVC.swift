//
//  ScanningVC.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ScanningVC: UIViewController {

    @IBOutlet weak var contentViewToTopSafeAreaConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewToBottomSafeAreaConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var barCodeTxtField: UITextField!
    
    @IBOutlet weak var confirmBarcodeBtn: UIButton!
    @IBOutlet weak var scanBarcodeBtn: UIButton!
    
    var viewModel: ScanningViewModel!
    
    var keyboardManager: MovingKeyboardDelegate?
    
    override func viewDidLoad() { super.viewDidLoad()
        
        barCodeTxtField.delegate = self
        
        loadKeyboardManager()
        
        bindUI()
        
    }
    
    private func bindUI() {
        
        logoImageView?.image = viewModel?.logo
        
        barCodeTxtField.rx.text
            .asDriver()
            .map { $0 ?? "" }
            .drive(viewModel.codeInput)
            .disposed(by: disposeBag)
        
        confirmBarcodeBtn.rx.controlEvent(.touchUpInside).asDriver()
            .drive(self.rx.dismissKeyboard)
            .disposed(by: disposeBag)
        
        scanBarcodeBtn.rx.controlEvent(UIControlEvents.touchUpInside).subscribe(onNext: { _ in
            print("open scan component")
        }).disposed(by: disposeBag)
        
    }
    
    private func loadKeyboardManager() {
        keyboardManager = MovingKeyboardDelegate.init(keyboardChangeHandler: { (halfKeyboardHeight) in
            var verticalShift: CGFloat = 0
            if UIDevice.current.userInterfaceIdiom == .phone {
                verticalShift = 2*halfKeyboardHeight
            } else if UIDevice.current.userInterfaceIdiom == .pad {
                verticalShift = halfKeyboardHeight
            }

            self.contentViewToTopSafeAreaConstraint!.constant += verticalShift
            self.contentViewToBottomSafeAreaConstraint!.constant -= verticalShift
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        })
    }
    
    private let disposeBag = DisposeBag()
}

extension ScanningVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print("entered code = \(try! viewModel.codeInput.value())")
        return true
    }
}
