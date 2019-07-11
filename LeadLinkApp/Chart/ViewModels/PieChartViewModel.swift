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
    var output: ReplaySubject<UIView> {get set}
}

class PieChartViewModel: PieChartViewModeling {
    
    private var campaign: Observable<Campaign>
    private var webReports: Observable<Results<RealmWebReportedAnswers>>
    private var viewFactory: PieChartViewBuilding
    private let bag = DisposeBag()
    
    private var newWebReports = [RealmWebReportedAnswers]()
    private var newCampaign: Campaign!
    
    var output = ReplaySubject<UIView>.create(bufferSize: 10) // output
    
    init(campaign: Observable<Campaign>,
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
                sSelf.newCampaign = campaign
                sSelf.newEventIsCatchedEmitUpdatedView(webReports: sSelf.newWebReports,
                                                       campaign: sSelf.newCampaign)
            }).disposed(by: bag)
    }
    
    private func newEventIsCatchedEmitUpdatedView(webReports: [RealmWebReportedAnswers], campaign: Campaign) {
        
        let view = viewFactory.makeOutput(webReports: webReports, campaign: campaign)
        output.onNext(view)
    }
    
    private func getNewestCampaignData() {
        
        if let appdel = UIApplication.shared.delegate as? AppDelegate { // DRY!
            appdel.downloadCampaignsQuestionsAndLogos()
        }
        
    }
    
}






protocol PieChartViewOutputing {
    var outputView: UIView! {get set}
    func makeOutput(webReports: [RealmWebReportedAnswers], campaign: Campaign) -> UIView
}

protocol PieChartViewBuilding: PieChartViewOutputing {}

class PieChartViewFactory: PieChartViewBuilding {
    
    var outputView: UIView!
    
    func makeOutput(webReports: [RealmWebReportedAnswers], campaign: Campaign) -> UIView {
        
//        let compartmentsGridView = createGridView(webReports: webReports, campaign: campaign)
//        let dateView = createDateView(webReports: webReports, campaign: campaign)

        let view = UIView.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 300, height: 200)))
        view.backgroundColor = .red
        
        return view
        
    }
    
}
