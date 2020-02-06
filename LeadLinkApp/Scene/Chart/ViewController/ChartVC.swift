//  ChartVC.swift
//  vc na sebi ima upper i lower view (u upper smesta PieChart (lib PieCharts) a u lower - tabelicu)
//
//
//  Created by Marko Dimitrijevic on 19/04/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
//import PieCharts

class ChartVC: UIViewController, Storyboarded {
    
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var lowerView: UIView!
    
    private let bag = DisposeBag()
    private var pieChartView: PieChart? { return upperView.subviews.first as? PieChart }
    
    var pieChartViewModel: PieChartViewModeling! // nek ti ubaci odg. Factory....
    var gridViewModel: GridViewModeling! // nek ti ubaci odg. Factory....
    
    override func viewDidAppear(_ animated: Bool) { super.viewDidAppear(animated)
        hookUpPieChartViewFromYourViewModel()
        hookUpGridViewFromYourViewModel()
    }
    
    private func hookUpPieChartViewFromYourViewModel() {
        pieChartViewModel.output.debounce(1.0, scheduler: MainScheduler())
            .subscribe(onNext: { [weak self] compartments in guard let sSelf = self else {return}
                sSelf.loadChart(compartments: compartments)
            })
            .disposed(by: bag)
    }
    
    private func loadChart(compartments: CompartmentValues) {
        upperView.removeAllSubviews()
        let pieChartView = NavusPieChart(frame: upperView.bounds)
        pieChartView.update(compartments: compartments)
        upperView.addSubview(pieChartView)
    }
    
    private func hookUpGridViewFromYourViewModel() {
        gridViewModel.output
            .subscribe(onNext: { [weak self] gridView in
                guard let sSelf = self else {return}
                
                sSelf.viewIsReady(gridView, forDestinationView: sSelf.lowerView)
            })
            .disposed(by: bag)
    }
    
    private func viewIsReady(_ view: UIView, forDestinationView destView: UIView) {
        removeViewIfPresent(inDestView: destView)
        addFormattedView(view: view, toDestView: destView)
    }
    
    private func removeViewIfPresent(inDestView destView: UIView) {
        if let childView = destView.subviews.first {
            childView.removeFromSuperview()
        }
    }
    
    private func addFormattedView(view: UIView, toDestView destView: UIView) {
        view.frame = destView.bounds
        destView.addSubview(view)
    }
    
}
