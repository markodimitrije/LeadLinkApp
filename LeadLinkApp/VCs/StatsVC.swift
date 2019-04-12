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
    var codesVC: CodesVC? = nil
    
    @IBOutlet weak var statisticsView: UIView?
    @IBOutlet weak var codesView: UIView?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tabControl: UISegmentedControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = codesView?.subviews.map {$0.removeFromSuperview()}
        codesVC!.view.frame = codesView?.bounds ?? self.view.bounds
        codesView?.addSubview(codesVC!.view)
        
        chartVC = storyboard!.instantiateViewController(withIdentifier: "ChartVC")
        
        bindTabControl()
    }
    
    private func bindTabControl() {
        tabControl?.rx.selectedSegmentIndex.subscribe(onNext: { index in
            _ = self.containerView.subviews.map {$0.removeFromSuperview()}
            switch index {
            case 0: self.containerView.addSubview(self.codesVC!.view)
            case 1: self.containerView.addSubview(self.chartVC!.view)
            default: break
            }
            
        }).disposed(by: disposeBag)
    }
    //
    private let disposeBag = DisposeBag()
    
}
