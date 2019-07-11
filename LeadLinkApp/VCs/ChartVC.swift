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
    
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var lowerView: UIView!
    
    private let bag = DisposeBag()
    
    var pieChartViewModel: PieChartViewModeling! // nek ti ubaci odg. Factory....
    var gridViewModel: GridViewModeling! // nek ti ubaci odg. Factory....
    
    override func viewDidLoad() { super.viewDidLoad()
        hookUpGridViewFromYourViewModel()
        hookUpPieChartViewFromYourViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) { super.viewDidAppear(animated)
        hookUpGridViewFromYourViewModel()
        hookUpPieChartViewFromYourViewModel()
    }
    
    private func hookUpGridViewFromYourViewModel() {
        gridViewModel.output
            .subscribe(onNext: { [weak self] gridView in
                
                guard let sSelf = self else {return}
                sSelf.gridViewIsReady(gridView)
                
            })
            .disposed(by: bag)
    }
    
    private func hookUpPieChartViewFromYourViewModel() {
        pieChartViewModel.output
            .subscribe(onNext: { [weak self] view in
                
                guard let sSelf = self else {return}
                sSelf.pieChartViewIsReady(view)
                
            })
            .disposed(by: bag)
    }
    
    // LOSE, ne zanima me da li je stack view ili view.. .. . .
    
    private func pieChartViewIsReady(_ view: UIView) {
        removePieChartViewIfPresent()
        addFormattedPieChartView(view: view)
    }
    
    private func removePieChartViewIfPresent() {
        if let childView = self.upperView.subviews.first {
            childView.removeFromSuperview()
        }
    }
    
    private func addFormattedPieChartView(view: UIView) {
        view.frame = upperView.bounds
        self.upperView.addSubview(view)
    }
    
    
    
    
    
    private func gridViewIsReady(_ gridView: UIStackView) {
        removeGridViewIfPresent()
        addFormattedGridView(gridTableView: gridView)
    }
    
    private func removeGridViewIfPresent() {
        if let childView = self.lowerView.subviews.first as? UIStackView {
            childView.removeFromSuperview()
        }
    }
    
    private func addFormattedGridView(gridTableView: UIStackView) {
        gridTableView.frame = lowerView.bounds
        self.lowerView.addSubview(gridTableView)
    }
    
}


