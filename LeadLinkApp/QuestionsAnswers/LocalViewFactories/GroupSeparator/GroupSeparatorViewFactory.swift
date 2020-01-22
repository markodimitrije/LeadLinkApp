//
//  GroupSeparatorViewFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 22/01/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import UIKit

extension GroupSeparatorViewFactory: GetViewProtocol {
    func getView() -> UIView {
        return myView
    }
}

class GroupSeparatorViewFactory {
    private let totalHeight: CGFloat = 20.0
    private let colorBarHeight: CGFloat = 8.0
    private let myView: UIView
    
    init() {
        let rect = CGRect(origin: .zero, size: CGSize(width: allowedQuestionsWidth, height: totalHeight))
        let baseView = IntrinsicView(frame: rect)
        baseView.backgroundColor = .white
        
        let childOriginY = (totalHeight / 2) - (colorBarHeight / 2)
        let childOrigin = CGPoint(x: 0, y: childOriginY)
        let rectBar = CGRect(origin: childOrigin,
                               size: CGSize(width: allowedQuestionsWidth, height: colorBarHeight))
        let barView = UIView(frame: rectBar)
        barView.backgroundColor = UIColor.red
        
        baseView.addSubview(barView)
        
        self.myView = baseView
    }
    
}
