//
//  ChartViewModel.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 08/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RxSwift

protocol GridViewModeling {
    var output: ReplaySubject<UIView> {get set}
}

class GridViewModel: GridViewModeling {
    
    private var campaign: Observable<CampaignProtocol?>
    private var webReports: Observable<[AnswersReportProtocol]>
    private var viewFactory: ChartGridViewBuilding
    private let bag = DisposeBag()
    
    private var newWebReports = [AnswersReportProtocol]()
    private var newCampaign: CampaignProtocol!
    
    var output = ReplaySubject<UIView>.create(bufferSize: 10) // output
    
    init(campaign: Observable<CampaignProtocol?>,
         webReports: Observable<[AnswersReportProtocol]>,
         viewFactory: ChartGridViewBuilding) {
        
        self.campaign = campaign
        self.webReports = webReports
        self.viewFactory = viewFactory
        
        self.listenUpdatesOnCampaignAndWebReports()
        
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
        
        let compartmentsGridView: UIStackView = viewFactory.makeOutput(webReports: webReports,
                                                                       campaign: campaign)
        output.onNext(compartmentsGridView)
    }
    
}
