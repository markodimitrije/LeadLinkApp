//
//  StatsVC.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 14/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class StatsVC: UIViewController, Storyboarded {
    var chartVC: UIViewController? = nil
    var codesVC: CodesVC? = nil
    
    @IBOutlet weak var statisticsView: UIView!
    @IBOutlet weak var codesView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = codesView.subviews.map {$0.removeFromSuperview()}
        codesView.addSubview(codesVC!.view)
    }
    
}
