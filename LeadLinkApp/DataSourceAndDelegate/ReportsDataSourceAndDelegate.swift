//
//  File.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 23/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ReportsDataSource: NSObject, UITableViewDataSource {
    
    weak var tableView: UITableView!
    var cellId: String
    var data = [Report]()
    
    init(campaignId: Int, reportsDataStore: ReportsDataStore, cellId: String) {
        self.cellId = cellId
        self.data = reportsDataStore.getReports(campaignId: campaignId)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ReportsTVC
        cell.update(report: data[indexPath.row])
        return cell
    }
    
}

class ReportsDelegate: NSObject, UITableViewDelegate {
    weak var tableView: UITableView!
    var selectedIndex = BehaviorRelay.init(value: IndexPath.init())//.skip(1) at destination // dummy initialization
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex.accept(indexPath)
    }
}


struct Report {
    var code: String
    var date: Date?
    var sync: Bool
    init(realmReport: RealmWebReportedAnswers) {
        self.code = realmReport.code
        self.date = realmReport.date
        self.sync = realmReport.success
    }
}
