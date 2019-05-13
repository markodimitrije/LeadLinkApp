//
//  SearchViewController.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 06/04/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


 class ChooseOptionsVC: UIViewController {
 
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
 
    var dataSourceAndDelegate: QuestionOptionsTableViewDataSourceAndDelegate!
    
    private var _options = PublishSubject<UITableViewDataSource>.init()
    
    public var doneWithOptions: Observable<UITableViewDataSource> {
        return doneBtn.rx.tap
                .withLatestFrom(_options.asObservable())
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSourceAndDelegate
        tableView.delegate = dataSourceAndDelegate
        setUpBindings()
    }
    
    private func setUpBindings() {
        
        dataSourceAndDelegate.tableView = tableView
        dataSourceAndDelegate.observableSearch = searchBar.rx.text
        
        _options.onNext(dataSourceAndDelegate) // mora da emituje odmah da bi postojao withLatestFrom
        
    }
 
    private let bag = DisposeBag()
 
 }
