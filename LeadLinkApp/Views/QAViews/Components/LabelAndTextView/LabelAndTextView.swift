//
//  LabelAndTextView.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 06/04/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class LabelAndTextView: UIView {
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var headlineLbl: UILabel!
    @IBOutlet weak var textView: UITextView! {didSet { formatTextView()}}
    
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
            return textView?.text
        }
        set {
            textView?.text = newValue ?? ""
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
        let nib = UINib(nibName: "LabelAndTextView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        textView.delegate = self
        
        self.addSubview(view)
        
    }
    
    func update(headlineText: String?, inputTxt: String?, placeholderTxt: String?) {
        self.headlineTxt = headlineText
        self.inputTxt = (inputTxt == nil || inputTxt == "") ? placeholderTxt : inputTxt
    }
    
    private func formatTextView() {
        textView.layer.borderColor = UIColor.fieldBorderGray.cgColor
        textView.layer.borderWidth = CGFloat.init(integerLiteral: 1)
        textView.layer.cornerRadius = 5.0
        textView.textColor = .lightGray
    }
    
}

extension LabelAndTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.deletePlaceholderAndSetTxtColorToBlack(textView: textView)
    }
    private func deletePlaceholderAndSetTxtColorToBlack(textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
}
