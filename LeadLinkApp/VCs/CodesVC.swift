//
//  CodesVC.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 20/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class CodesVC: UIViewController, Storyboarded {
    
    @IBOutlet weak var tableView: UITableView!
    
    let factory: AppDependencyContainer = {
        return AppDependencyContainer()
    }()
    
    var codesDataSource: CodesDataSource? {
        didSet {
            print("codesDataSource injected from outside")
        }
    }
    var codesDelegate = CodesDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("codesDataSource != nil", codesDataSource != nil)
        codesDataSource?.tableView = self.tableView
        self.tableView.dataSource = codesDataSource
    }
    
    deinit {
        print("CodesVC is deinit")
    }
    
}
