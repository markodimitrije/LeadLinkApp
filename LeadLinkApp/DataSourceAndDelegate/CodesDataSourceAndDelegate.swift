//
//  CodesDataSourceAndDelegate.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 21/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CodesDataSource: NSObject, UITableViewDataSource {
    
    weak var tableView: UITableView!
    var cellId: String
    var data = [Code]()
    
    init(campaignId: Int, codesDataStore: CodesDataStore, cellId: String) {
        self.cellId = cellId
        self.data = codesDataStore.getCodes(campaignId: campaignId)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        populate(cell: cell, at: indexPath)
        return cell
    }
    
    private func populate(cell: UITableViewCell, at indexPath: IndexPath) {
        cell.textLabel?.text = data[indexPath.row].value
    }
    
}

class CodesDelegate: NSObject, UITableViewDelegate {
    weak var tableView: UITableView!
    var selectedIndex = BehaviorRelay.init(value: IndexPath.init())//.skip(1) at destination // dummy initialization
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex.accept(indexPath)
    }
}






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
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) //as! CodeCell
        //cell.populate(report)
        //populate(cell: cell, at: indexPath)
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
}
