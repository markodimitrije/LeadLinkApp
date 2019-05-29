//
//  DividerView.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class DividerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    
    // new code:
    convenience init(position: CGPoint) {
        var frame = CGRect(x: 0, y: 0, width: 100, height: 60)
        frame.origin = position
        self.init(frame: frame)
        loadViewFromNib ()
    }
    
    convenience init(frame: CGRect, image: UIImage?, msgText: String?) {
        self.init(frame: frame)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DividerView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(view)
    }
}
