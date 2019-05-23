//
//  Code.swift
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


class AnswersReportsState { // ovo je trebalo da zoves viewModel-om !
    
    private var reports: Results<AnswersReport>? {
        
        guard let realm = try? Realm.init() else {return nil} // ovde bi trebalo RealmError!
        
        return realm.objects(AnswersReport.self)
    }
    
    private var shouldReportToWeb: Bool {
        
        guard let reports = reports else {return false} // ovde bi trebalo RealmError!
        
        return reports.isEmpty
    }
    
    private var timer: Timer?
    
    private let bag = DisposeBag()
    
    // INPUT
    
    let report = BehaviorRelay<AnswersReport?>.init(value: nil)
    
    // OUTPUT
    
    let webNotified = BehaviorRelay<(AnswersReport, Bool)?>.init(value: nil)
    
    init() {
        
        bindInputWithOutput()
        
    }
    
    private func bindInputWithOutput() { print("AnswersReportsState.bindInputWithOutput")
        
        report
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
            RealmDataPersister.shared.save(reportsAcceptedFromWeb: [report])
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
        
        RealmDataPersister.shared.saveToRealm(report: report)
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
        
        print("prijavi ovaj report = \(report)")
        
        return AnswersApiController.shared.notifyWeb(withReports: [report]).map { (reports, success) -> (AnswersReport, Bool) in
            return (reports.first!, success)
        }
        
    }
    
}
