//
//  ChartVC.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 19/04/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

class ChartVC: UIViewController, Storyboarded {
    
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var gridTableView: UIView!
    
    private var barOrChartInfo: BarOrChartInfo?
    
    var chartViewModel: ChartViewModel! // nek ti ubaci odg. Factory....
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hookUpChartDataFromYourViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadGridTableView()
    }
    
    private func hookUpChartDataFromYourViewModel() {
        chartViewModel.output
            .subscribe(onNext: { barOrChartInfo in print("create your views and display them....")
                print("barOrChartInfo = \(barOrChartInfo.otherDevicesSyncedCount)")
                self.barOrChartInfo = barOrChartInfo
            })
            .disposed(by: bag)
    }
    
    private func loadGridTableView() {
        let chartViewFactory = ChartViewFactory(barOrChartInfo: self.barOrChartInfo!)
        let chartTableView = chartViewFactory.gridView
        chartTableView.frame = gridTableView.bounds
        self.gridTableView.addSubview(chartTableView)
    }
    
}
