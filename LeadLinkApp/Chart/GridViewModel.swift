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
    
    private var campaign: Campaign
    private var webReports: Observable<Results<RealmWebReportedAnswers>>
    
    var output = ReplaySubject<UIStackView>.create(bufferSize: 10) // output

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
                let gridView = sSelf.createGridView(barOrChartInfo: barOrChartData)
                sSelf.output.onNext(gridView)
            })
            .disposed(by: bag)
    }
    
    private let bag = DisposeBag()
    
    private func createGridView(barOrChartInfo: BarOrChartInfo) -> UIStackView {
        
        let gridViewFactory = CompartmentsInGridViewFactory(barOrChartInfo: barOrChartInfo)
        let gridTableView = gridViewFactory.gridView
        
        return gridTableView
    }
}
