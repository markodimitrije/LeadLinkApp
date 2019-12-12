//
//  OptInViewItem.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 11/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class OptInViewItem: NSObject, QuestionPageGetViewProtocol {
        
    private var myView: UIView!

    init(optInViewFactory: OptInViewFactory) {
        self.myView = optInViewFactory.getView()
    }
    
    func getView() -> UIView {
        return self.myView
    }
    
}
