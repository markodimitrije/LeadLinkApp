//
//  PieChartViewModel.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 11/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RxSwift

protocol PieChartViewModeling {
    var output: ReplaySubject<CompartmentValues> {get set}
}

class PieChartViewModel: PieChartViewModeling {
    
    private var campaign: Observable<CampaignProtocol?>
    private var webReports: Observable<[AnswersReportProtocol]>
    private let bag = DisposeBag()
    
    private var newWebReports = [AnswersReportProtocol]()
    private var newCampaign: CampaignProtocol!
    
    var output = ReplaySubject<CompartmentValues>.create(bufferSize: 10) // output
    
    init(campaign: Observable<CampaignProtocol?>, webReports: Observable<[AnswersReportProtocol]>) {
        
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
                sSelf.newWebReports = webReports
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
    
    private func newEventIsCatchedEmitUpdatedView(webReports: [AnswersReportProtocol], campaign: CampaignProtocol) {

        let chartData = CompartmentValues(campaign: newCampaign, webReports: newWebReports)
        output.onNext(chartData)
    }
    
    private func getNewestCampaignData() {
        
        if let appdel = UIApplication.shared.delegate as? AppDelegate { // DRY!
            appdel.downloadCampaignsQuestionsAndLogos()
        }
    }
    
}
