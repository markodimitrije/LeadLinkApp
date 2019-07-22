//
//  LocalComponentsViewFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class LocalComponentsViewFactory {
    
    private var localComponentsSize: LocalComponentsSize
    init(localComponentsSize: LocalComponentsSize) {
        self.localComponentsSize = localComponentsSize
    }
    
    func makeTermsNoSwitchView(tag: Int, optIn: OptIn?) -> TermsNoSwitchView {
        
        let (width, height) = localComponentsSize.getComponentWidthAndHeight(type: TermsNoSwitchView.self)
        
        let rect = CGRect.init(center: CGPoint.zero,
                               size: CGSize.init(width: width,
                                                 height: height))
        let view = TermsNoSwitchView.init(frame: rect)
        view.textView.tag = tag
        view.configureTxtViewWithHyperlinkText(tag: tag, optIn: optIn)
        return view
    }
    
}

class LocalComponentsSize {
    
    func getComponentWidthAndHeight<T: UIView>(type: T.Type) -> (CGFloat, CGFloat) {
        
        var width = (UIApplication.topViewController()?.view.frame.width ?? UIScreen.main.bounds.width)
        var height = heightForView(ofType: type)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            width *= 0.6
            height *= 1.1
        }
        
        return (width, height)
    }
    
    private func heightForView<T: UIView>(ofType type: T.Type) -> CGFloat {
        if type is SaveButton.Type {
            return 60.0
        }
        if type is TermsNoSwitchView.Type {
            return 100.0
        }
        print("o-o, vracam NULU !")
        return 0
    }
    
}
