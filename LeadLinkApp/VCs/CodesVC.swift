//
//  CodesVC.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 20/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class CodesVC: UIViewController, Storyboarded {
    
    var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CodeCell")
        return tableView
    }()
    
    var codesDataSource: CodesDataSource?
    var codesDelegate: CodesDelegate?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(codesDataSource: CodesDataSource?, codesDelegate: CodesDelegate?) {
        self.init(nibName: nil, bundle: nil)
        codesDataSource?.tableView = self.tableView
        tableView.dataSource = codesDataSource
        tableView.delegate = codesDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = self.view.bounds
        self.view.addSubview(tableView)
        tableView.reloadData()
    }
    
}
