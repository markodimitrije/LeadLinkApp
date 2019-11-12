//
//  DateFormatter+Extensions.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    convenience init(format: String) {
        self.init()
        dateFormat = format
        locale = Locale.current
    }
}
