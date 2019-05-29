//
//  TextFieldStacker.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 17/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit

// ovaj objerkat treba da zna da slozi onoliko komponenti koliko si mu poslao
// treba da mu kazes koliko ih ima i koje su

class ViewStacker: UIView {
    
    @IBOutlet weak var viewStacker: UIStackView!
    
    var components = [UIView]() {
        didSet {
            layoutComponents()
        }
    }
    
    var answer: Answer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    convenience init(frame: CGRect,
                     components: [UIView]) {
        self.init(frame: frame)
        self.components = components
        layoutComponents()
    }
    
    convenience init(frame: CGRect, components: [UIView], answer: Answer?) {
        self.init(frame: frame)
        self.answer = answer
        self.components = components
        layoutComponents()
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ViewStacker", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(view)
        
    }
    
    // ovde izracunaj koliko stacks treba da imas
    //hard coded poslate views slozi u onoliko horizontalnih stackviews formula ti je ((n+1)/2 ) + 1
    private func layoutComponents() {
        
        for (index, v) in components.enumerated() {
            if index == 0 {
                viewStacker.addArrangedSubview(v)
                self.layoutSubviews()
            } else {
                viewStacker.insertArrangedSubview(v, at: index)
                self.layoutSubviews()
            }
            
        }
        
        if let oneRowStacker = components.first as? OneRowStacker,
            oneRowStacker.components.first is RowsStackedEqually {//, {
            viewStacker.distribution = .fillEqually
        }
        
        let totalHeight = viewStacker.bounds.height
        
        viewStacker.frame = CGRect.init(origin: CGPoint.zero,
                                        size: CGSize.init(width: viewStacker.bounds.width, height: (totalHeight + 8) * CGFloat(components.count)))
        
    }
    
    func addAsLast(view: UIView) {
        viewStacker.addArrangedSubview(view)
    }
    
}
