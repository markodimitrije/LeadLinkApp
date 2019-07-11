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
    private var viewFactory: ChartGridViewBuilding
    private let bag = DisposeBag()
    
    private var newWebReports = [RealmWebReportedAnswers]()
    private var newCampaign: Campaign!
    
    var output = ReplaySubject<UIStackView>.create(bufferSize: 10) // output
    
    init(campaign: Observable<Campaign>,
         webReports: Observable<Results<RealmWebReportedAnswers>>,
         viewFactory: ChartGridViewBuilding) {
        
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
                sSelf.newCampaign = campaign
                sSelf.newEventIsCatchedEmitUpdatedView(webReports: sSelf.newWebReports,
                                                       campaign: sSelf.newCampaign)
            }).disposed(by: bag)
    }
    
    private func newEventIsCatchedEmitUpdatedView(webReports: [RealmWebReportedAnswers], campaign: Campaign) {
        
        let compartmentsGridView: UIStackView = viewFactory.makeOutput(webReports: webReports,
                                                                       campaign: campaign)
        output.onNext(compartmentsGridView)
    }
    
    private func getNewestCampaignData() {
        
        if let appdel = UIApplication.shared.delegate as? AppDelegate { // DRY!
            appdel.downloadCampaignsQuestionsAndLogos()
        }
        
    }
    
}






protocol ChartGridViewOutputing {
    var outputView: UIStackView! {get set}
    func makeOutput(webReports: [RealmWebReportedAnswers], campaign: Campaign) -> UIStackView
}

protocol ChartGridViewBuilding: ChartGridViewOutputing {}

class ChartGridViewFactory: ChartGridViewBuilding {
    
    var outputView: UIStackView!
    
    func makeOutput(webReports: [RealmWebReportedAnswers], campaign: Campaign) -> UIStackView {
        
        let compartmentsGridView = createGridView(webReports: webReports, campaign: campaign)
        let dateView = createDateView(webReports: webReports, campaign: campaign)

        let stackView = UIStackView(arrangedSubviews: [compartmentsGridView, dateView])
        stackView.axis = .vertical // format...
        
        return stackView
        
    }
    
    private func createGridView(webReports: [RealmWebReportedAnswers], campaign: Campaign) -> UIView {
        let barOrChartData = BarOrChartData(campaign: campaign, webReports: webReports)
        let compartmentsInGridViewFactory = CompartmentsInGridViewFactory(barOrChartInfo: barOrChartData)
        return compartmentsInGridViewFactory.outputView
    }
    
    private func createDateView(webReports: [RealmWebReportedAnswers], campaign: Campaign) -> UIView {
        let chartLastSyncedAt = ChartRefreshDateCalculator(webReports: webReports, campaign: campaign).date
        let lastDateSyncViewFactory = LastDateSyncViewFactory(date: chartLastSyncedAt)
        return lastDateSyncViewFactory.outputView
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
//        outputView = UIView.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 200, height: 20)))
//        outputView.backgroundColor = .red
        let frame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 200, height: 20))
        let dateView = DateView(frame: frame)
        dateView.update(descText: "Last updated at: ",
                        date: date)
        
        outputView = dateView

    }
    
}
