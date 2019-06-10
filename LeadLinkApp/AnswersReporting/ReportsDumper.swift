//
//  ReportsDumper.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 04/11/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import Realm

class ReportsDumper {
    
    let bag = DisposeBag.init()
    
    var timer: Observable<Int>?
    
    var isRunning = BehaviorRelay.init(value: false) // timer
    
    var timerFired = BehaviorRelay.init(value: ()) // timer events
    
    var timeToSendReport: Observable<Bool> {
        return timerFired
                    .asObservable()
                    //.map {return true} // temp ON
                    .withLatestFrom(connectedToInternet()) // temp OFF
    }
    
    var reportsDeleted: BehaviorRelay<Bool> = {
        return BehaviorRelay.init(value: RealmDataPersister.shared.getFailedReports().isEmpty)
    }()
    
    init() { print("ReportsDumper.INIT, fire every 8 sec or on wi-fi changed")
        
        hookUpTimer()
        
        hookUpNotifyWebRepeteadly()
        
        hookUpAllCodesReportedToWeb()
        
    }
    
    // Output
    
    var oReportsDumped = BehaviorRelay<Bool>.init(value: false)
    
    // MARK:- API
    func sendToWebUnsycedReports() {
        
        let reports = RealmDataPersister.shared.getFailedReports()
        
        self.reportToWeb(reports: reports)
            .subscribe(onNext: { success in
                if success {
                    
                    let reported = reports.map({ report -> AnswersReport in
                        return report.updated(withSuccess: success)
                    })
                    RealmDataPersister.shared.updateReports(reported)
                        .subscribe(onNext: { deleted in
                            
                            self.reportsDeleted.accept(deleted)
                        })
                        .disposed(by: self.bag)
                }
            })
            .disposed(by: self.bag)
    }
    
    
    // MARK:- Private
    
    private func hookUpTimer() {
        
        isRunning.asObservable()
            .debug("isRunning")
            .flatMapLatest {  isRunning in
                isRunning ? Observable<Int>.interval(Constants.TimeInterval.reportUnsyncBarcodesEvery,
                                                     scheduler: MainScheduler.instance) : .empty()
            }
            //.flatMapWithIndex { (int, index) in
        .enumerated().flatMap { (int, index) in
                return Observable.just(index)
            }
            .debug("timer")
            .subscribe({[weak self] _ in
                guard let sSelf = self else {return}
                sSelf.timerFired.accept(())
            })
            .disposed(by: bag)
        
        isRunning.accept(true) // one time pokreni timer
        
    }
    
    private func hookUpNotifyWebRepeteadly() {
        
        timeToSendReport
            .subscribe(onNext: { [weak self] timeToReport in // print("timeToReport = \(timeToReport)")
                
                guard let sSelf = self else {return}

                sSelf.sendToWebUnsycedReports()
                
            })
            .disposed(by: bag)
        
    }
    
    private func hookUpAllCodesReportedToWeb() {
        
        reportsDeleted.asObservable()
            .subscribe(onNext: { [weak self] success in
                guard let sSelf = self else {return}
                if success { print("all good, ugasi timer!")
                    
                    sSelf.isRunning.accept(false)  // ugasi timer, uspesno si javio i obrisao Realm
                    sSelf.oReportsDumped.accept(true)
                }
            })
            .disposed(by: bag)
    }
    
    private func reportToWeb(reports: [AnswersReport]) -> Observable<Bool> { print("reportSavedCodesToWeb")
        
        guard !reports.isEmpty else { print("ReportsDumper.reportSavedCodes/ internal error...")
            return Observable.just(false)
        }
        
        return AnswersApiController.shared
            .notifyWeb(withReports: reports) // Observable<[AnswersReport], Bool>
            .map { (reports, success) -> Bool in
                if success {
                    return true
                } else {
                    return false
                }
            }
    }
    
}


enum ReportToWebError: Error {
    case noCodesToReport
    case notConfirmedByServer // nije 201
}
