//
//  ReportAnswersToWebWorker.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 04/11/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import RxSwift
import RxCocoa
import RealmSwift

protocol ReportAnswersToWebWorkerProtocol {
    //input
    var report: BehaviorRelay<AnswersReportProtocol?> {get set}
    //output
    var webNotified: BehaviorRelay<(AnswersReportProtocol, Bool)?> {get set}
}

class ReportAnswersToWebWorker: ReportAnswersToWebWorkerProtocol {
    
    private let reportAnswersDataStore: AnswersReportDataStoreProtocol
    
    private var shouldReportToWeb: Bool {
        return reportAnswersDataStore.getReports().isEmpty
    }
    
    private var timer: Timer?
    
    private let bag = DisposeBag()
    
    // INPUT
    
    var report = BehaviorRelay<AnswersReportProtocol?>.init(value: nil)
    
    // OUTPUT
    
    var webNotified = BehaviorRelay<(AnswersReportProtocol, Bool)?>.init(value: nil)
    
    init(reportAnswersDataStore: AnswersReportDataStoreProtocol) {
        self.reportAnswersDataStore = reportAnswersDataStore
        bindInputWithOutput()
    }
    
    private func bindInputWithOutput() { print("AnswersReportsToWebState.bindInputWithOutput")
        
        report
            .skipWhile {$0 == nil}
            .asObservable()
            .subscribe(onNext: { [weak self] report in
                guard let sSelf = self, let report = report else {return}

            let obs = sSelf.reportImidiatelly(report: sSelf.report.value)
            obs
                .subscribe(onNext: { arg in
                    let (report, success) = (arg.0, arg.1)
                    sSelf.reportedToWeb(report: report, with: success)
                }, onError: { err in
                    sSelf.reportedToWeb(report: report, with: false)
                }).disposed(by: sSelf.bag)
            })
            .disposed(by: bag)
    }
    
    private func reportedToWeb(report: AnswersReportProtocol, with success: Bool) {
        
        var myReport = report
        
        webNotified.accept((myReport, success)) // postavi na svoj Output
        
        myReport.success = success
        
        if success { // hard-coded of
            print("jesam success, implement save to realm!")
            AnswersReportDataStore.shared.save(reports: [myReport])
                .subscribe(onNext: { saved in
                    print("code successfully reported to web, save in your archive")
                }).disposed(by: bag)
        }
        
        if !success {
            codeReportFailed(myReport) // izmestac code
        }
    }
    
    private func codeReportFailed(_ report: AnswersReportProtocol) {
        
        print("codeReportFailed/ snimi ovaj report.code \(report.code) u realm")
        
        _ = AnswersReportDataStore.shared.save(reports: [report])
        // okini process da javljas web-u sve sto ima u realm (codes)
        if reportsDumperWorker == nil {
            reportsDumperWorker = ReportsDumperWorker(answersReportDataStore: reportAnswersDataStore) // u svom init, zna da javlja reports web-u...
            reportsDumperWorker.oReportsDumped
                .asObservable()
                .subscribe(onNext: { (success) in
                    if success {
                        reportsDumperWorker = nil
                    }
                })
                .disposed(by: bag)
        }
    }
    
    private func reportImidiatelly(report: AnswersReportProtocol?) -> Observable<(AnswersReportProtocol, Bool)> {
        
        guard let report = report else {return Observable.empty()}
//        print("prijavi ovaj report = \(report)")
        return AnswersRemoteAPI.shared.notifyWeb(withReports: [report]).map { (reports, success) -> (AnswersReportProtocol, Bool) in
            return (reports.first!, success)
        }
    }
}
