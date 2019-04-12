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
    
    var codesDataSource: CodesDataSource?
    var codesDelegate: CodesDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codesDataSource?.tableView = self.tableView
        codesDelegate?.tableView = self.tableView
        self.tableView.dataSource = codesDataSource
        self.tableView.delegate = codesDelegate
    }
    
    deinit {
        print("CodesVC.deinit")
    }
    
}
