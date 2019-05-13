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
    @IBOutlet weak var textView: UITextView!
    
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
        
        self.addSubview(view)
        
    }
    
    func update(headlineText: String?, inputTxt: String?) {
        self.headlineTxt = headlineText
        self.inputTxt = inputTxt
    }
    
}
