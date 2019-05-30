//
//  SyncReportsBtn.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 30/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class ReportsSyncBtn: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        format()
    }
    private func format() {
        self.layer.cornerRadius = CGFloat.init(integerLiteral: 15)
        self.layer.borderColor = UIColor.init(red: 178/255, green: 178/255, blue: 178/255, alpha: 1.0).cgColor
        self.layer.borderWidth = CGFloat.init(integerLiteral: 1)
    }
}
