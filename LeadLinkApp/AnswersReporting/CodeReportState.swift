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


class CodeReportsState { // ovo je trebalo da zoves viewModel-om !
    
    private var codeReports: Results<AnswersReport>? {
        
        guard let realm = try? Realm.init() else {return nil} // ovde bi trebalo RealmError!
        
        return realm.objects(AnswersReport.self)
    }
    
    private var shouldReportToWeb: Bool {
        
        guard let reports = codeReports else {return false} // ovde bi trebalo RealmError!
        
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
    
    private func bindInputWithOutput() { print("CodeReportsState.bindInputWithOutput")
        
        report
            .asObservable()
            .subscribe(onNext: { [weak self] report in guard let sSelf = self else {return}
                
                let obs = sSelf.reportImidiatelly(report: sSelf.report.value)
                obs
                    .subscribe(onNext: { (report, success) in

                        sSelf.webNotified.accept((report, success)) // postavi na svoj Output
                        
                        report.success = success
                        
//                        report.success = false // hard-coded
//                        sSelf.codeReportFailed(report) // hard-coded
                        
                        if success { // hard-coded of
                            print("jesam success, implement save to realm!")
                            RealmDataPersister.shared.save(reportsAcceptedFromWeb: [report])
                                .subscribe(onNext: { saved in
                                    print("code successfully reported to web, save in your archive")
                                }).disposed(by: sSelf.bag)
                        }

                        if !success {
                            sSelf.codeReportFailed(report) // izmestac code
                        }

                    })
                    .disposed(by: sSelf.bag)
            })
            .disposed(by: bag)
        
    }
    
    private func codeReportFailed(_ report: AnswersReport) {
        
        print("codeReportFailed/ snimi ovaj report.code \(report.code) u realm")
        
        RealmDataPersister.shared.saveToRealm(report: report)
        // okini process da javljas web-u sve sto ima u realm (codes)
        if reportsDumper == nil {
            reportsDumper = ReportsDumper() // u svom init, zna da javlja reports web-u...
            reportsDumper.oCodesDumped
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
        
        return AnswersApiController.shared.notifyWeb(withCodeReports: [report]).map { (reports, success) -> (AnswersReport, Bool) in
            return (reports.first!, success)
        }
        
        //return AnswersApiController.shared.notifyWeb(withCodeReports: [report])
        
    }
    
    // implement me...
    private func reportToWeb(codeReports: Results<AnswersReport>?) {
        
        // sviranje... treba mi servis da javi sve.... za sada posalji samo jedan...
        
        guard let report = codeReports?.first else {
            print("nemam ni jedan code da report!...")
            return
        }
        
        print("CodeReportsState/ javi web-u za ovaj report:")
        print("code.payload = \(report.payload)")

    }
    
}
