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
    @IBOutlet weak var gridView: UIView!
    
    private let bag = DisposeBag()
    private var barOrChartInfo: BarOrChartInfo? { // imam ref ovde jer ce mi trebati za dijagram
        didSet {
            loadCompartmentsInGridView()
        }
    }
    
    var chartViewModel: ChartViewModel! // nek ti ubaci odg. Factory....
    
    override func viewDidLoad() { super.viewDidLoad()
        hookUpChartDataFromYourViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) { super.viewDidAppear(animated)
        loadCompartmentsInGridView()
    }
    
    private func hookUpChartDataFromYourViewModel() {
        chartViewModel.output
            .subscribe(onNext: { [weak self] barOrChartInfo in
                
                guard let sSelf = self else {return}
                sSelf.barOrChartInfo = barOrChartInfo
                
            })
            .disposed(by: bag)
    }
    
    private func loadCompartmentsInGridView() {
        
        guard let barOrChartInfo = self.barOrChartInfo else {return}

        resizeGridViewIfPresent()
        
        addGridView(barOrChartInfo: barOrChartInfo)
        
    }
    
    private func resizeGridViewIfPresent() {
        if let childView = self.gridView.subviews.first as? UIStackView {
            childView.frame = self.gridView.bounds
            return
        }
    }
    
    private func addGridView(barOrChartInfo: BarOrChartInfo) {
        let gridViewFactory = CompartmentsInGridViewFactory(barOrChartInfo: barOrChartInfo)
        let gridTableView = gridViewFactory.gridView
        
        gridTableView.frame = gridView.bounds
        self.gridView.addSubview(gridTableView)
    }
}
