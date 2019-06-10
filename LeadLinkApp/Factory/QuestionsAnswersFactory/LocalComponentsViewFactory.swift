//
//  LocalComponentsViewFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class LocalComponentsViewFactory {
    func makeTermsNoSwitchView(tag: Int) -> TermsNoSwitchView {
        
        let (width, height) = LocalComponentsViewFactory.getComponentWidthAndHeight()
        
        let rect = CGRect.init(center: CGPoint.zero,
                               size: CGSize.init(width: width,
                                                 height: height))
        let view = TermsNoSwitchView.init(frame: rect)
        view.textView.tag = tag
        view.configureTxtViewWithHyperlinkText(tag: tag)
        return view
    }
    
    static func getComponentWidthAndHeight() -> (CGFloat, CGFloat) {
        var width = CGFloat(0.0)
        var height = CGFloat(0.0)
        if UIDevice.current.userInterfaceIdiom == .pad {
            width = (UIApplication.topViewController()?.view.frame.width ?? UIScreen.main.bounds.width) / 2.0
            height = 160.0
        } else if UIDevice.current.userInterfaceIdiom == .phone{
            width = UIApplication.topViewController()?.view.frame.width ?? UIScreen.main.bounds.width
            height = 120
        }
        return (width, height)
    }
    
}
