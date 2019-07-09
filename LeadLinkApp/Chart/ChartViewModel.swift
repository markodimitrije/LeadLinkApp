//
//  ChartViewModel.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 08/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class ChartViewModel {
    
    private var campaign: Campaign
    private var webReports: Observable<Results<RealmWebReportedAnswers>>
    
    let output = ReplaySubject<BarOrChartInfo>.create(bufferSize: 10) // output

    init(campaign: Campaign, webReports: Observable<Results<RealmWebReportedAnswers>>) {
        self.campaign = campaign
        self.webReports = webReports
        self.hookUpWebReportsToChartOrBarData()
    }
    
    private func hookUpWebReportsToChartOrBarData() { // input to output
        webReports
            .subscribe(onNext: { [weak self] webReports in
                guard let sSelf = self else {return}
                let barOrChartData = BarOrChartData(campaign: sSelf.campaign, webReports: webReports.toArray())
                sSelf.output.onNext(barOrChartData)
            })
            .disposed(by: bag)
    }
    
    private let bag = DisposeBag()
}

protocol BarOrChartInfo {
    //init(campaign: Campaign, webReports: [RealmWebReportedAnswers])
    var otherDevicesSyncedCount: Int {get set}
    var thisDeviceSyncedCount: Int {get set}
    var thisDeviceNotSyncedCount: Int {get set}
}

struct BarOrChartData: BarOrChartInfo {

    private var campaign: Campaign
    private var webReports: [RealmWebReportedAnswers]
    
    var otherDevicesSyncedCount = 0
    var thisDeviceSyncedCount = 0
    var thisDeviceNotSyncedCount = 0
    
    init(campaign: Campaign, webReports: [RealmWebReportedAnswers]) {
        self.campaign = campaign
        self.webReports = webReports
        self.populateMyVars()
    }
    
    private mutating func populateMyVars() {
        loadOtherDevicesSyncedCount()
        loadThisDeviceSyncedCount()
        loadThisDeviceNotSyncedCount()
    }
    
    private mutating func loadOtherDevicesSyncedCount() {
        _otherDevicesSyncedCount = campaign.number_of_responses
    }
    
    private mutating func loadThisDeviceSyncedCount() {
        _thisDeviceSyncedCount = webReports.filter {$0.success}.count
    }
    
    private mutating func loadThisDeviceNotSyncedCount() {
        _thisDeviceNotSyncedCount = webReports.filter {!$0.success}.count
    }
}
