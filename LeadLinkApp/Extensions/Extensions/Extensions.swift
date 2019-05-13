//
//  Extensions.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 10/04/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

// MARK:- Always extensions // ok to be in Pods

extension UIView {
    static func closestParentObject<T: UIView, U: UIView>(for object: T, ofType type: U.Type) -> U? {
        guard let parent = object.superview else {
            return nil
        }
        if let parent = parent as? U {
            return parent
        } else {
            return closestParentObject(for: parent, ofType: type)
        }
    }
}

extension UIView {
    func removeAllSubviews() {
        _ = subviews.map {$0.removeFromSuperview()}
    }
    // increse or decrease just
    func resizeHeight(by amount: CGFloat) {
        let actualFrame = self.frame
        let new = CGRect.init(origin: actualFrame.origin, size: CGSize.init(width: actualFrame.width, height: actualFrame.height + amount))
        self.frame = new
    }
    func resizeWidth(by amount: CGFloat) {
        let actualFrame = self.frame
        let new = CGRect.init(origin: actualFrame.origin, size: CGSize.init(width: actualFrame.width + amount, height: actualFrame.height))
        self.frame = new
    }
    func resize(byWidth width: CGFloat, byHeight height: CGFloat) {
        self.resizeWidth(by: width)
        self.resizeHeight(by: height)
    }
}

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}
