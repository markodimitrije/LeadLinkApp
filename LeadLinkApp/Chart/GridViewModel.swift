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

protocol GridViewModeling {
    var output: ReplaySubject<UIStackView> {get set}
}

class GridViewModel: GridViewModeling {
    
    private var campaign: Observable<Campaign>
    private var webReports: Observable<Results<RealmWebReportedAnswers>>
    private let bag = DisposeBag()
    
    private var newWebReports = [RealmWebReportedAnswers]()
    private var newCampaign: Campaign!
    
    var output = ReplaySubject<UIStackView>.create(bufferSize: 10) // output
    
    init(campaign: Observable<Campaign>, webReports: Observable<Results<RealmWebReportedAnswers>>) {
        self.campaign = campaign
        self.webReports = webReports
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
                    sSelf.newEventIsCatchedUpdateView(webReports: sSelf.newWebReports,
                                                      campaign: sSelf.newCampaign)
                }
            }).disposed(by: bag)
    }
    
    private func listenUpdatesOnCampaign() {
        campaign
            .subscribe(onNext: { [weak self] campaign in
                guard let sSelf = self else {return}
                sSelf.newCampaign = campaign
                sSelf.newEventIsCatchedUpdateView(webReports: sSelf.newWebReports,
                                                  campaign: sSelf.newCampaign)
            }).disposed(by: bag)
    }
    
    private func newEventIsCatchedUpdateView(webReports: [RealmWebReportedAnswers], campaign: Campaign) {
        
        let lastChartSyncDate = getLatestChartSyncDate(webReports: webReports, campaign: campaign)
        print("lastChartSyncDate = \(lastChartSyncDate)")
        
        let barOrChartData = BarOrChartData(campaign: campaign, webReports: webReports)
        let compartmentsGridView = createCompartmentsGridView(barOrChartInfo: barOrChartData)
        print("emituj update-ovani compartmentsGridView !!!")
        output.onNext(compartmentsGridView)
    }
    
    private func getLatestChartSyncDate(webReports: [RealmWebReportedAnswers], campaign: Campaign) -> Date {
        if webReports.isEmpty {return campaign.dateReadAt!}
        let lastWebReportDate = (webReports.compactMap {$0.date}).max()!
        let lastCampaignDate = campaign.dateReadAt // rename !!!
        return max(lastWebReportDate, lastCampaignDate!)
    }
    
    private func createCompartmentsGridView(barOrChartInfo: BarOrChartInfo) -> UIStackView {
        
        let gridViewFactory = CompartmentsInGridViewFactory(barOrChartInfo: barOrChartInfo)
        let gridTableView = gridViewFactory.gridView
        
        return gridTableView
    }
    
    private func getNewestCampaignData() {
        
        if let appdel = UIApplication.shared.delegate as? AppDelegate { // DRY!
            appdel.downloadCampaignsQuestionsAndLogos()
        }
        
    }
    
}

