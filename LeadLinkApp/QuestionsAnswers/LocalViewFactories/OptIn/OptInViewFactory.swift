//
//  OptInViewFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 11/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class OptInViewFactory: GetViewProtocol {
    
    private var textView: UITextView!
    private var myView: UIView!
    private let optIn: OptInProtocol
    
    func getView() -> UIView {
        return self.myView
    }
    
    init(optIn: OptInProtocol, titleWithHiperlinkViewFactory: TextWithHiperlinkViewFactory) {
        self.optIn = optIn
        self.myView = titleWithHiperlinkViewFactory.getView()
    }
    
}
