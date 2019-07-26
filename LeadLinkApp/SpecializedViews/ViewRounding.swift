//
//  ViewRounding.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 26/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

protocol BorderCornerRounding {
    func roundCorner(withRadius: CGFloat)
}

protocol BorderColoring {
    func drawBorder(withLineWidth: CGFloat, andColor: UIColor)
}

protocol ViewRounding: BorderCornerRounding, BorderColoring {}

extension ViewRounding where Self: UIView {
    func roundCorner(withRadius radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    func drawBorder(withLineWidth lineWidth: CGFloat, andColor color: UIColor) {
        self.layer.borderWidth = lineWidth
        self.layer.borderColor = color.cgColor
    }
}
