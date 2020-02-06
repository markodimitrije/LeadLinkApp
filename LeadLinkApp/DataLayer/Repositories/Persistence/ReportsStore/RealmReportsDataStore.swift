//
//  RealmReportsDataStore.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 23/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RealmSwift

import RxSwift
import RxCocoa

public class RealmReportsDataStore: ReportsDataStore {
    
    internal var campaignId: Int
    
    // output:
    var oReports = BehaviorRelay<[RealmWebReportedAnswers]>.init(value: [])
    
    init(campaignId: Int) {
        self.campaignId = campaignId
        self.hookUpOutput()
    }
    
    private func hookUpOutput() {
        let realm = RealmFactory.make()
        let realmReports = realm.objects(RealmWebReportedAnswers.self)
                                .filter("campaignId == %@", "\(campaignId)")
        
        Observable.collection(from: realmReports)
            .subscribe(onNext: { [weak self] results in guard let sSelf = self else {return}
                let reports = Array(results)
                
                sSelf.oReports.accept(reports)
                
            }).disposed(by: bag)
    }
    
    private let bag = DisposeBag()
    
}
