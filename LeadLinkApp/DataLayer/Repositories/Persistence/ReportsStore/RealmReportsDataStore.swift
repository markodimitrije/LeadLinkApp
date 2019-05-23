//
//  RealmReportsDataStore.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 23/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import PromiseKit
import Realm
import RealmSwift
import RxRealm

import RxSwift
import RxCocoa

public class RealmReportsDataStore: ReportsDataStore {
    
    private var realm = try! Realm.init()
    private var campaignsDataStore: CampaignsDataStore
    
    // output:
    var oReports = BehaviorRelay<[RealmWebReportedAnswers]>.init(value: [])
    
    init(campaignsDataStore: CampaignsDataStore, realm: Realm? = nil) {
        self.campaignsDataStore = campaignsDataStore
        if let realm = realm {
            self.realm = realm
        }
        self.hookUpOutput()
    }
    
    private func hookUpOutput() {
        guard let realm = try? Realm.init() else {return}
        let realmReports = realm.objects(RealmWebReportedAnswers.self)
        Observable.collection(from: realmReports)
            .subscribe(onNext: { [weak self] results in guard let sSelf = self else {return}
                let reports = Array(results)
                print("emitujem nove reports iz baze = \(reports)")
                sSelf.oReports.accept(reports)
            }).disposed(by: bag)
    }
    
    deinit {
        print("o-o, RealmReportsDataStore is deinit!!!")
    }
    
    private let bag = DisposeBag()
    
}
