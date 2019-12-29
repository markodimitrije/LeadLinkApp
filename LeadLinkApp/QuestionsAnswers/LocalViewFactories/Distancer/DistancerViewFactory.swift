//
//  DistancerViewFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 29/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class DistancerViewFactory: GetViewProtocol {
    private let myView: UIView
    func getView() -> UIView {
        return myView
    }
    init(height: CGFloat) {
        let frame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: allowedQuestionsWidth,
                                                                        height: height))
        let distancerView = IntrinsicView(frame: frame)
        self.myView = distancerView
    }
}
