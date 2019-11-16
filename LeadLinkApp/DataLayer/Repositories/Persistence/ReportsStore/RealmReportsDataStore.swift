//
//  RealmReportsDataStore.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 23/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import PromiseKit
import RealmSwift

import RxSwift
import RxCocoa

public class RealmReportsDataStore: ReportsDataStore {
    
    private var realm = try! Realm.init()
    private var campaignsDataStore: CampaignsDataStore
    internal var campaignId: Int
    
    // output:
    var oReports = BehaviorRelay<[RealmWebReportedAnswers]>.init(value: [])
    
    init(campaignId: Int, campaignsDataStore: CampaignsDataStore, realm: Realm? = nil) {
        self.campaignId = campaignId
        self.campaignsDataStore = campaignsDataStore
        if let realm = realm {
            self.realm = realm
        }
        self.hookUpOutput()
    }
    
    private func hookUpOutput() {
        guard let realm = try? Realm.init() else {return}
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
