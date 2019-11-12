//
//  Data+Extensions.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

extension Data {
    var toString: String? {
        return String(data: self, encoding: String.Encoding.utf8)
    }
}
