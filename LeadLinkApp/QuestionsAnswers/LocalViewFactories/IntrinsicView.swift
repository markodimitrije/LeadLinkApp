//
//  IntrinsicView.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 29/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class IntrinsicView: UIView {
    private var myView: UIView
    override init(frame: CGRect) {
        self.myView = UIView(frame: frame)
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        self.myView = UIView.init(frame: CGRect.zero)
        super.init(coder: coder)
    }
    override var intrinsicContentSize: CGSize {
        return myView.frame.size
    }
}
