//
//  Extensions.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 10/04/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

// MARK:- Always extensions // ok to be in Pods

import Foundation

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}


