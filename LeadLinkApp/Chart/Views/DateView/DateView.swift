//
//  DateView.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class DateView: UIView {
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    private var descText: String? {
        get {
            return descLabel.text
        }
        set {
            descLabel.text = newValue
        }
    }
    
    private var date: Date? {
        get {
            return valueLabel.text?.toDate()
        }
        set {
            guard let newValue = newValue else {
                valueLabel.text = ""; return
            }
            valueLabel.text = newValue.toString(format: newValue.defaultDateFormat)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DateView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(view)
        
    }
    
    func update(descText: String, date: Date) {
        
        descLabel.text = descText
        self.date = date
    }
    
}











