//
//  Code.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 04/11/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import RxSwift
import RxCocoa
import RealmSwift

protocol AnswersReportsToWebStateProtocol {
    //input
    var report: BehaviorRelay<AnswersReport?> {get set}
    //output
    var webNotified: BehaviorRelay<(AnswersReport, Bool)?> {get set}
}

class AnswersReportsToWebState: AnswersReportsToWebStateProtocol {
    
    private var reports = [AnswersReport]()
    
    private var shouldReportToWeb: Bool {
        return reports.isEmpty
    }
    
    private var timer: Timer?
    
    private let bag = DisposeBag()
    
    // INPUT
    
    var report = BehaviorRelay<AnswersReport?>.init(value: nil)
    
    // OUTPUT
    
    var webNotified = BehaviorRelay<(AnswersReport, Bool)?>.init(value: nil)
    
    init() {
        bindInputWithOutput()
        self.reports = AnswersReportDataStore.shared.getReports()
    }
    
//    init(answersReportDataStore: AnswersReportDataStore) { // TODO - DIP + remove .shared
//        self.reports = answersReportDataStore.getReports()
//        bindInputWithOutput()
//    }
    
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
    
    private func reportedToWeb(report: AnswersReport, with success: Bool) {
        
        webNotified.accept((report, success)) // postavi na svoj Output
        
        report.success = success
        
        if success { // hard-coded of
            print("jesam success, implement save to realm!")
            AnswersReportDataStore.shared.save(reportsAcceptedFromWeb: [report])
                .subscribe(onNext: { saved in
                    print("code successfully reported to web, save in your archive")
                }).disposed(by: bag)
        }
        
        if !success {
            codeReportFailed(report) // izmestac code
        }
    }
    
    private func codeReportFailed(_ report: AnswersReport) {
        
        print("codeReportFailed/ snimi ovaj report.code \(report.code) u realm")
        
        _ = AnswersReportDataStore.shared.saveToRealm(report: report)
        // okini process da javljas web-u sve sto ima u realm (codes)
        if reportsDumper == nil {
            reportsDumper = ReportsDumper() // u svom init, zna da javlja reports web-u...
            reportsDumper.oReportsDumped
                .asObservable()
                .subscribe(onNext: { (success) in
                    if success {
                        reportsDumper = nil
                    }
                })
                .disposed(by: bag)
        }
        
    }
    
    private func reportImidiatelly(report: AnswersReport?) -> Observable<(AnswersReport, Bool)> {
        
        guard let report = report else {return Observable.empty()}
        
//        print("prijavi ovaj report = \(report)")
        
        return AnswersRemoteAPI.shared.notifyWeb(withReports: [report]).map { (reports, success) -> (AnswersReport, Bool) in
            return (reports.first!, success)
        }
        
    }
    
}
