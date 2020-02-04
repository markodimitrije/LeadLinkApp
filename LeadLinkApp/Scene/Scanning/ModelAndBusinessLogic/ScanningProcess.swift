//
//  ScanningProcess.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 04/02/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct ScanningProcess {
    
    var lastScanedCode: String = ""
    var congressDelegate: Delegate?
    var hasConsent = false
    
    init(lastScanedCode: String = "", congressDelegate: Delegate? = nil, hasConsent: Bool = false) {
        self.lastScanedCode = lastScanedCode
        self.congressDelegate = congressDelegate
        self.hasConsent = hasConsent
    }
}
