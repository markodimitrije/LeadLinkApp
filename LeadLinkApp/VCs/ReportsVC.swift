//
//  ReportsVC.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 23/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

class ReportsVC: UIViewController, Storyboarded {
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func syncTapped(_ sender: UIButton) {
        syncTapped()
    }
    
    private var myReportsDumper: ReportsDumper? = reportsDumper
    
    var dataSource: ReportsDataSource?
    var delegate: ReportsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource?.tableView = self.tableView
        delegate?.tableView = self.tableView
        self.tableView.dataSource = dataSource
        self.tableView.delegate = delegate
        
        listenTableTapEvents()
//        monitorVisibility()
    }
    
    deinit { print("ReportsVC.deinit") }
    
    private func listenTableTapEvents() {
        delegate?.selectedIndex.skip(1)
            .subscribe(onNext: { [weak self] indexPath in guard let sSelf = self else {return}
                let index = indexPath.row
                guard let report = sSelf.dataSource?.data[index] else {return}
                
                let nextVC = sSelf.factory.makeQuestionsAnswersViewController(codeValue: report.code,
                                                                              campaignId: report.campaignId)
                guard let statsVC = sSelf.parent as? StatsVC else { fatalError() }
                statsVC.navigationController?.pushViewController(nextVC, animated: true)
            }).disposed(by: bag)
    }
    
    private func syncTapped() {
        reportsDumper?.sendToWebUnsycedReports()
    }
    
//    private func formatSyncBtn() {
//        syncBtn.layer.cornerRadius = CGFloat.init(integerLiteral: 15)
//        syncBtn.layer.borderColor = UIColor.init(red: 178/255, green: 178/255, blue: 178/255, alpha: 1.0).cgColor
//        syncBtn.layer.borderWidth = CGFloat.init(integerLiteral: 1)
//    }
    
//    private func monitorVisibility() {
//
//        Observable.combineLatest(myReportsDumper?.oReportsDumped.asObservable() ?? Observable.just(true), connectedToInternet()) {
//            (reportsDumped, isConected) -> Bool in
//
//            if reportsDumped {
//                return true // isHidden
//            } else if isConected {
//                return false
//            }
//            return false
//        }
//            .asDriver(onErrorJustReturn: false)
//            .drive(syncBtn.rx.isHidden)
//            .disposed(by: bag)
//
//    }
    
    private let factory = AppDependencyContainer()
    let bag = DisposeBag()
}

class ReportsSyncBtn: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        format()
    }
    private func format() {
        self.layer.cornerRadius = CGFloat.init(integerLiteral: 15)
        self.layer.borderColor = UIColor.init(red: 178/255, green: 178/255, blue: 178/255, alpha: 1.0).cgColor
        self.layer.borderWidth = CGFloat.init(integerLiteral: 1)
    }
}
