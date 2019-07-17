//
//  PieChartViewModel.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 11/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

protocol PieChartViewModeling {
    var output: ReplaySubject<BarOrChartData> {get set}
}

class PieChartViewModel: PieChartViewModeling {
    
    private var campaign: Observable<Campaign?>
    private var webReports: Observable<Results<RealmWebReportedAnswers>>
    private var viewFactory: PieChartViewBuilding
    private let bag = DisposeBag()
    
    private var newWebReports = [RealmWebReportedAnswers]()
    private var newCampaign: Campaign!
    
    var output = ReplaySubject<BarOrChartData>.create(bufferSize: 10) // output
    
    init(campaign: Observable<Campaign?>,
         webReports: Observable<Results<RealmWebReportedAnswers>>,
         viewFactory: PieChartViewBuilding) {
        
        self.campaign = campaign
        self.webReports = webReports
        self.viewFactory = viewFactory
        
        self.listenUpdatesOnCampaignAndWebReports()
        self.getNewestCampaignData()
    }
    
    private func listenUpdatesOnCampaignAndWebReports() { // input to output
        listenUpdatesOnWebReports()
        listenUpdatesOnCampaign()
    }
    
    private func listenUpdatesOnWebReports() {
        webReports
            .subscribe(onNext: { [weak self] webReports in
                guard let sSelf = self else {return}
                sSelf.newWebReports = webReports.toArray()
                if sSelf.newCampaign != nil {
                    sSelf.newEventIsCatchedEmitUpdatedView(webReports: sSelf.newWebReports,
                                                           campaign: sSelf.newCampaign)
                }
            }).disposed(by: bag)
    }
    
    private func listenUpdatesOnCampaign() {
        campaign
            .subscribe(onNext: { [weak self] campaign in
                guard let sSelf = self else {return}
                guard let campaign = campaign else {return}
                sSelf.newCampaign = campaign
                sSelf.newEventIsCatchedEmitUpdatedView(webReports: sSelf.newWebReports,
                                                       campaign: sSelf.newCampaign)
            }).disposed(by: bag)
    }
    
    private func newEventIsCatchedEmitUpdatedView(webReports: [RealmWebReportedAnswers], campaign: Campaign) {
        
        let barOrChartData = BarOrChartData(campaign: campaign, webReports: webReports)
        let compartmentBuilder = CompartmentBuilder(barOrChartInfo: barOrChartData)
        
//        let view = viewFactory.makeOutput(compartmentBuilder: compartmentBuilder)
//        output.onNext(view)
        let chartData = BarOrChartData(campaign: newCampaign, webReports: newWebReports)
        output.onNext(chartData)
    }
    
    private func getNewestCampaignData() {
        
        if let appdel = UIApplication.shared.delegate as? AppDelegate { // DRY!
            appdel.downloadCampaignsQuestionsAndLogos()
        }
        
    }
    
}
