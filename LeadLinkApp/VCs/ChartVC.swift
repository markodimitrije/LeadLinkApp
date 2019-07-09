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
    
    var chartViewModel: ChartViewModel! // nek ti ubaci odg. Factory....
    
    override func viewDidLoad() { super.viewDidLoad()
        hookUpChartDataFromYourViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) { super.viewDidAppear(animated)
        hookUpChartDataFromYourViewModel()
    }
    
    private func hookUpChartDataFromYourViewModel() {
        chartViewModel.output
            .subscribe(onNext: { [weak self] gridView in
                
                guard let sSelf = self else {return}
                sSelf.gridViewIsReady(gridView)
                
            })
            .disposed(by: bag)
    }
    
    private func gridViewIsReady(_ gridView: UIStackView) {
        removeGridViewIfPresent()
        addFormattedGridView(gridTableView: gridView)
    }
    
    private func removeGridViewIfPresent() {
        if let childView = self.gridView.subviews.first as? UIStackView {
            childView.removeFromSuperview()
        }
    }
    
    private func addFormattedGridView(gridTableView: UIStackView) {
        gridTableView.frame = gridView.bounds
        self.gridView.addSubview(gridTableView)
    }
    
}


