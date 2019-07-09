//
//  SingleRowGridTableView.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class SingleRowGridTableView: UIView {
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SingleRowGridTableView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(view)
        
    }
    
//    func update(color: UIColor, desc: String, value: Int) {
//        colorView.backgroundColor = color
//        descLabel.text = desc
//        valueLabel.text = "\(value)"
//    }
    
    func update(singleCompartmentInfo: SingleCompartment) {
        colorView.backgroundColor = singleCompartmentInfo.color
        descLabel.text = singleCompartmentInfo.name
        valueLabel.text = "\(singleCompartmentInfo.value)"
    }
    
}















