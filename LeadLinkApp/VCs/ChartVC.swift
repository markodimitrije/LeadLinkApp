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
    
    private let bag = DisposeBag()
    private var barOrChartInfo: BarOrChartInfo? { // imam ref ovde jer ce mi trebati za dijagram
        didSet {
            loadGridTableView()
        }
    }
    
    var chartViewModel: ChartViewModel! // nek ti ubaci odg. Factory....
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hookUpChartDataFromYourViewModel()
    }
    
    private func hookUpChartDataFromYourViewModel() {
        chartViewModel.output
            .subscribe(onNext: { barOrChartInfo in print("create your views and display them....")
                
                self.barOrChartInfo = barOrChartInfo
                
            })
            .disposed(by: bag)
    }
    
    private func loadGridTableView() {
        
        guard let barOrChartInfo = self.barOrChartInfo else {return}
        
        let chartViewFactory = ChartViewFactory(barOrChartInfo: barOrChartInfo)
        let chartTableView = chartViewFactory.gridView
        chartTableView.frame = gridTableView.bounds
        self.gridTableView.addSubview(chartTableView)
    }
    
}
