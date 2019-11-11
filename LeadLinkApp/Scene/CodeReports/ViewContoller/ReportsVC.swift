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
    private let questionsAnswersVcFactory = QuestionsAnswersViewControllerFactory(appDependancyContainer: factory)
    private let bag = DisposeBag()
    
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
                
                let nextVC = sSelf.questionsAnswersVcFactory.makeVC(codeValue: report.code,
                                                                    campaignId: report.campaignId)
                
                guard let statsVC = sSelf.parent as? StatsVC else { fatalError() }
                statsVC.navigationController?.pushViewController(nextVC, animated: true)
            }).disposed(by: bag)
    }
    
    private func syncTapped() {
        reportsDumper?.sendToWebUnsycedReports()
    }
    
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
    
}
