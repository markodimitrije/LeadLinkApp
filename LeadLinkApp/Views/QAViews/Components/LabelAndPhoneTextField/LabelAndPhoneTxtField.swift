//
//  LabelAndPhoneTxtField.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 06/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import PhoneNumberKit

class LabelAndPhoneTxtField: UIView, UITextFieldDelegate {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var headlineLbl: UILabel!
    @IBOutlet weak var textField: PhoneNumberTextField! {
        didSet {
            formatBorder()
            formatPhoneNumberProperties()
            textField.delegate = self
        }
    }
    
    private let phoneValidator = PhoneValidation()
    private let phoneNumberKit = PhoneNumberKit()
    
    private var headlineTxt: String? {
        get {
            return headlineLbl?.text
        }
        set {
            headlineLbl?.text = newValue
        }
    }
    private var inputTxt: String? {
        get {
            return textField?.text
        }
        set {
            textField?.text = newValue ?? ""
        }
    }
    private var placeholderTxt: String? {
        get {
            return textField?.placeholder
        }
        set {
            textField?.placeholder = newValue ?? ""
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib() // ne zaboravi OVO !
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    convenience init(frame: CGRect, headlineText: String?, inputTxt: String?) {
        self.init(frame: frame)
        self.headlineTxt = headlineText // prerano za postavljanje outlet-a !!
        self.inputTxt = inputTxt // prerano za postavljanje outlet-a !!
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "LabelAndPhoneTxtField", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(view)
        
    }
    
    private func formatBorder() {
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
        textField.layer.borderColor = UIColor.fieldBorderGray.cgColor
    }
    
    private func formatPhoneNumberProperties() {
        do {
            let phoneNumber = try phoneNumberKit.parse(textField.text ?? "")
            inputTxt = phoneNumberKit.format(phoneNumber, toType: .international)
        }
        catch {
            //print("Generic parser error")
        }
        
    }
    
    // MARK:- API
    
    func update(headlineText: String?, inputTxt: String?, placeholderTxt: String?) {
        self.headlineTxt = headlineText
        self.inputTxt = inputTxt
        self.placeholderTxt = placeholderTxt
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        formatTextFieldColorAccordingTo(text: textField.text ?? "")
        
    }
    
    private func formatTextFieldColorAccordingTo(text: String) {
        
        var numberWithoutFormat = text
        _ = ["+", "-", "(", ")", " "].map { char in
            numberWithoutFormat = remove(char: char, fromText: numberWithoutFormat)
        }

        if !phoneValidator.isValidPhone(phone: numberWithoutFormat) {
            if numberWithoutFormat == "" {
                textField.layer.borderColor = UIColor.black.cgColor
            } else {
                textField.layer.borderColor = UIColor.red.cgColor
            }
        } else {
            textField.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    private func remove(char: String, fromText text: String) -> String {
        return text.replacingOccurrences(of: char, with: "")
    }
    
}
