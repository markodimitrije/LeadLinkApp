//
//  CGRect+Extensions.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

extension CGRect {
    var center: CGPoint {
        return CGPoint.init(x: self.origin.x - self.size.width/2, y: self.origin.y - self.size.height/2)
    }
    init(center: CGPoint, size: CGSize) {
        let orig = CGPoint.init(x: center.x - size.width/2, y: center.y - size.height/2)
        let rect = CGRect.init(origin: orig, size: size)
        self = rect
    }
}
