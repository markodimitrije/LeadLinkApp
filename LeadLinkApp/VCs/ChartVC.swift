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
        hookUpPieChartViewFromYourViewModel()
        hookUpGridViewFromYourViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) { super.viewDidAppear(animated)
        hookUpPieChartViewFromYourViewModel()
        hookUpGridViewFromYourViewModel()
    }
    
    private func hookUpPieChartViewFromYourViewModel() {
        pieChartViewModel.output
            .subscribe(onNext: { [weak self] pieChartView in
                guard let sSelf = self else {return}
                
                sSelf.viewIsReady(pieChartView, forDestinationView: sSelf.upperView)
                
            })
            .disposed(by: bag)
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


