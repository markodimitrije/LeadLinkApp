//
//  ChartVC.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 19/04/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import PieCharts

class ChartVC: UIViewController, Storyboarded {
    
    @IBOutlet weak var upperView: PieChart!
    @IBOutlet weak var lowerView: UIView!
    
    private let bag = DisposeBag()
    
    var pieChartViewModel: PieChartViewModeling! // nek ti ubaci odg. Factory....
    var gridViewModel: GridViewModeling! // nek ti ubaci odg. Factory....
    
    override func viewDidLoad() { super.viewDidLoad()
//        hookUpPieChartViewFromYourViewModel()
//        hookUpGridViewFromYourViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) { super.viewDidAppear(animated)
        hookUpPieChartViewFromYourViewModel()
        hookUpGridViewFromYourViewModel()
    }
    
    private func hookUpPieChartViewFromYourViewModel() {
        pieChartViewModel.output
            .subscribe(onNext: { [weak self] chartData in
                guard let sSelf = self else {return}
                
                sSelf.chartDataReady(chartData)
                
            })
            .disposed(by: bag)
    }
    
    private func chartDataReady(_ chartData: BarOrChartData) {

        let pieSliceModelCreator = PieSliceModelCreator.init(chartData: chartData)
        upperView.models = pieSliceModelCreator.models
        
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // REFACTOR FROM HERE !
//
//    private func formatPieChart() {
//        setChartInnerAndOuterRadius()
//        setChartBackgroundColor()
//        setGapBetweenPies()
//        setReferenceAngle()
//        setAnimationDuration()
//    }
//
//    private func setChartInnerAndOuterRadius() {
//        upperView.innerRadius = 0.25 * upperView.bounds.width
//        upperView.outerRadius = 0.50 * upperView.bounds.width
//    }
//
//    private func setChartBackgroundColor() {
//        upperView.backgroundColor = .yellow
//    }
//
//    private func setGapBetweenPies() {
//        upperView.strokeWidth = 10.0
//        upperView.strokeColor = .white
//    }
//
//    private func setReferenceAngle() {
//        upperView.referenceAngle = 270.0
//    }
//
//    private func setAnimationDuration() {
//        upperView.animDuration = 0.01
//    }
    
}

