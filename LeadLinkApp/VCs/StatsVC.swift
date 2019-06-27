//
//  StatsVC.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 14/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class StatsVC: UIViewController, Storyboarded {
    
    var chartVC: UIViewController? = nil
    var reportsVC: ReportsVC? = nil
    
    @IBOutlet weak var statisticsView: UIView?
    @IBOutlet weak var codesView: UIView?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tabControl: UISegmentedControl?
    
    override func viewDidLoad() { super.viewDidLoad()
        bindTabControl()
    }
    
    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated)
        loadReportsVC()
        loadChartVC()
    }
    
    override func viewDidAppear(_ animated: Bool) { super.viewDidAppear(animated)
        loadChartVC()
    }
    
    private func bindTabControl() {
        tabControl?.rx.selectedSegmentIndex.subscribe(onNext: { index in
            _ = self.containerView.subviews.map {$0.removeFromSuperview()}
            switch index {
            //case 0: self.containerView.addSubview(self.codesVC!.view)
            case 0: self.containerView.addSubview(self.reportsVC!.view)
            case 1: self.containerView.addSubview(self.chartVC!.view)
            default: break
            }
            
        }).disposed(by: disposeBag)
    }
    
    private func loadReportsVC() {
        _ = codesView?.subviews.map {$0.removeFromSuperview()}
        
        guard let reportsVC = reportsVC else {return}

        reportsVC.view.frame = containerView?.bounds ?? codesView?.bounds ?? CGRect.zero

        codesView?.addSubview(reportsVC.view)

        self.addChild(reportsVC)
    }
    
    private func loadChartVC() {
        chartVC = storyboard!.instantiateViewController(withIdentifier: "ChartVC")
        chartVC?.view.frame = containerView?.bounds ?? codesView?.bounds ?? CGRect.zero
    }
    
    private let disposeBag = DisposeBag()
    
}
