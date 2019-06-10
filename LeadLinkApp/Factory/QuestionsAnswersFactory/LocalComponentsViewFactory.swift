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
        let rect = CGRect.init(center: CGPoint.zero, size: CGSize.init(width: 200, height: 80))
        let view = TermsNoSwitchView.init(frame: rect)
        view.textView.tag = tag
        view.configureTxtViewWithHyperlinkText(tag: tag)
        return view
    }
}
