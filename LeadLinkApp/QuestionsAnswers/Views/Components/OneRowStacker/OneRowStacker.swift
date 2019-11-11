//
//  File.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 17/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class OneRowStacker: UIView {
    
    @IBOutlet weak var stackView: UIStackView!
    
    var components: [UIView] {
        return stackView.arrangedSubviews
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    // ovo je konstruktor koji radi posao..
    convenience init?(frame: CGRect,
                     components: [UIView]) {
        guard components.count <= 3 else {return nil}
        
        self.init(frame: frame)
        
        layoutComponents(components: components)
        
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "OneRowStacker", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(view)
        
    }

    override func awakeFromNib() {
        layoutComponents(components: [])
    }
    
    func insertAsLast(view: UIView) {
        stackView.addArrangedSubview(view)
    }
    
    // imas case sa 1,2,3 components.
    private func layoutComponents(components: [UIView]) {
        
        for (index,view) in components.enumerated() {
        
            let mySize = view.bounds.size
            
            let newWidth = mySize.width * CGFloat(1)/CGFloat(components.count)
            
            let or = CGPoint.init(x: view.frame.origin.x + (CGFloat(8.0) + CGFloat(index) * newWidth),
                                  y: view.frame.origin.y)
            
            let size = CGSize.init(width: newWidth, height: mySize.height)
            
            let rect = CGRect.init(origin: or, size: size)
            
            let resizedView = view
            
            resizedView.frame = rect
            
            stackView.addArrangedSubview(resizedView)
            
        }
        
    }
    
}
