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
    
    
    
    var chartViewModel: ChartViewModel! // nek ti ubaci odg. Factory....
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hookUpChartDataFromYourViewModel()
    }
    
    private func hookUpChartDataFromYourViewModel() {
        chartViewModel.output
            .subscribe(onNext: { barOrChartInfo in print("create your views and display them....")
                print("barOrChartInfo = \(barOrChartInfo.otherDevicesSyncedCount)")
            })
            .disposed(by: bag)
    }
    
}
