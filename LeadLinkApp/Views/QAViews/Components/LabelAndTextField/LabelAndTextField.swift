//
//  QuestionTextView.swift
//  LeadLink
//
//  Created by Marko Dimitrijevic on 11/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class LabelAndTextField: UIView {
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var headlineLbl: UILabel!
    @IBOutlet weak var textField: UITextField! {didSet { formatBorder()}}
    
    var headlineTxt: String? {
        get {
            return headlineLbl?.text
        }
        set {
            headlineLbl?.text = newValue
        }
    }
    
    var inputTxt: String? {
        get {
            return textField?.text
        }
        set {
            textField?.text = newValue ?? ""
        }
    }
    
    var placeholderTxt: String? {
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
        let nib = UINib(nibName: "LabelAndTextField", bundle: bundle)
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
    
    // MARK:- API
    
    func update(headlineText: String?, inputTxt: String?, placeholderTxt: String?) {
        self.headlineTxt = headlineText
        self.inputTxt = inputTxt
        self.placeholderTxt = placeholderTxt
    }
    
}
