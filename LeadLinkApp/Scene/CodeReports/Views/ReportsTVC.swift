//
//  ReportTVC.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 23/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class ReportsTVC: UITableViewCell {

    @IBOutlet weak var codeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var syncLbl: UILabel!
    
    func update(report: ReportProtocol) {
        codeLbl.text = report.code//report.code.count >= 6 ? trimmedToSixCharactersCode(code: report.code) : report.code
        dateLbl.text = report.date.toString(format: Date.codeReportShortFormatString)
        syncLbl.text = report.sync ? "YES" : "NO"
        self.setColor(synced: report.sync)
    }
    
    private func setColor(synced: Bool) {
        syncLbl.textColor = synced ? UIColor.green : UIColor.red
    }
    
}
