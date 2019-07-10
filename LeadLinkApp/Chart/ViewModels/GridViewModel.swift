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
                    sSelf.newEventIsCatchedEmitUpdatedView(webReports: sSelf.newWebReports,
                                                           campaign: sSelf.newCampaign)
                }
            }).disposed(by: bag)
    }
    
    private func listenUpdatesOnCampaign() {
        campaign
            .subscribe(onNext: { [weak self] campaign in
                guard let sSelf = self else {return}
                sSelf.newCampaign = campaign
                sSelf.newEventIsCatchedEmitUpdatedView(webReports: sSelf.newWebReports,
                                                       campaign: sSelf.newCampaign)
            }).disposed(by: bag)
    }
    
    private func newEventIsCatchedEmitUpdatedView(webReports: [RealmWebReportedAnswers], campaign: Campaign) {
        
        let compartmentsGridView: UIStackView = ChartGridViewFactory(webReports: webReports,
                                                                     campaign: campaign).outputView
        output.onNext(compartmentsGridView)
    }
    
    private func getNewestCampaignData() {
        
        if let appdel = UIApplication.shared.delegate as? AppDelegate { // DRY!
            appdel.downloadCampaignsQuestionsAndLogos()
        }
        
    }
    
}






protocol ChartGridViewInitializing {
    init(webReports: [RealmWebReportedAnswers], campaign: Campaign)
}

protocol ChartGridViewOutputing {
    var outputView: UIStackView! {get set}
}

protocol ChartGridViewBuilding: ChartGridViewInitializing, ChartGridViewOutputing {}

class ChartGridViewFactory: ChartGridViewBuilding {
    
    private var barOrChartData: BarOrChartData
    private var compartmentsInGridViewFactory: CompartmentsInGridViewFactory // treba DI! ChartGridViewBuilding
    private var lastDateSyncViewFactory: LastDateSyncViewFactory // treba DI! LastRefreshChartViewBuilding
    
    var outputView: UIStackView!
    
    required init(webReports: [RealmWebReportedAnswers], campaign: Campaign) {
        
        // load my vars
        self.barOrChartData = BarOrChartData(campaign: campaign, webReports: webReports)
        self.compartmentsInGridViewFactory = CompartmentsInGridViewFactory(barOrChartInfo: barOrChartData)
        let chartLastSyncedAt = ChartRefreshDateCalculator(webReports: webReports, campaign: campaign).date
        self.lastDateSyncViewFactory = LastDateSyncViewFactory(date: chartLastSyncedAt)
        
        outputView = compartmentsInGridViewFactory.outputView
        let syncedDateView = self.lastDateSyncViewFactory.outputView
        
        outputView.addArrangedSubview(syncedDateView!)
        
    }
    
}








protocol LastDateSyncViewInitializing {
    init(date: Date)
}

protocol LastDateSyncViewOutputing {
    var outputView: UIView! {get set}
}

protocol LastRefreshChartViewBuilding: LastDateSyncViewInitializing, LastDateSyncViewOutputing {}

class LastDateSyncViewFactory: LastRefreshChartViewBuilding {
    
    var outputView: UIView!
    
    required init(date: Date) {
        outputView = UIView.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 200, height: 60)))
        outputView.backgroundColor = .red
    }
    
}
