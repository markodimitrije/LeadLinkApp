//
//  QuestionGroupFooterView.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 09/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class QuestionGroupFooterView: UIView {
    
    @IBOutlet weak var barView: UIView!
    
    var color: UIColor? {
        get {
            return barView.backgroundColor
        }
        set {
            barView.backgroundColor = newValue
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
    
    convenience init(frame: CGRect, color: UIColor?) {
        self.init(frame: frame)
        update(color: color)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "QuestionGroupFooterView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(view)
        
    }
    
    func update(color: UIColor?) {
        self.color = color
    }
    
}
