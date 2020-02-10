//
//  RealmDataPersister.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 30/10/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm

protocol AnswersReportDataStoreProtocol {
    func getWebReportedAnswers() -> Observable<[AnswersReportProtocol]>
    func getReports() -> [AnswersReportProtocol]
    func getFailedReports() -> [AnswersReportProtocol]
    func updateReports(_ reports: [AnswersReportProtocol]) -> Observable<Bool>
    func save(reports: [AnswersReportProtocol]) -> Observable<Bool>
}

struct AnswersReportDataStore: AnswersReportDataStoreProtocol {
    
    static var shared = AnswersReportDataStore()
    
    // observable OUTPUT
    
    func getWebReportedAnswers() -> Observable<[AnswersReportProtocol]> {
        
        let realm = RealmFactory.make()
        let results = realm.objects(RealmWebReportedAnswers.self)
        
        return Observable
            .collection(from: results) // this is live source !!
            .map {$0.toArray()}
            .map { (realmAnswersReportsArray) -> [AnswersReportProtocol] in
                return realmAnswersReportsArray.map {AnswersReport.init(realmAnswersReport: $0)}
        }
    }

    // MARK:- Reports
    
    func getReports() -> [AnswersReportProtocol] {
        
        let realm = RealmFactory.make()
        let realmResults = realm.objects(RealmWebReportedAnswers.self).toArray()
        
        return realmResults.map {AnswersReport.init(realmAnswersReport: $0)}
    }
    
    func getFailedReports() -> [AnswersReportProtocol] {
        return getReports().filter {$0.success == false}
    }
    
    // MARK:- Update report(s)
    
    func updateReports(_ reports: [AnswersReportProtocol]) -> Observable<Bool> {
        
        let realm = RealmFactory.make()
        let records = reports.map {RealmWebReportedAnswers.create(report: $0)}
        
        do {
            try realm.write {
                realm.add(records, update: .modified)
            }
            print("RealmDataPersister.deleteAnswersReports: update Reported AnswersReports")
            return Observable.just(true)
        } catch {
            return Observable.just(false)
        }
        
    }
    
    // MARK:- Save report(s)
    
    func save(reports: [AnswersReportProtocol]) -> Observable<Bool> {

        let realm = RealmFactory.make()

        let realmWebReportedCodes = reports.enumerated().map { (offset, report) -> RealmWebReportedAnswers in
            let record = RealmWebReportedAnswers.create(report: report)
            return record
        }

        do {
            try realm.write {
                realm.add(realmWebReportedCodes, update: .modified)
                print("total count of realmWebReportedCodes = \(realmWebReportedCodes.count), saved to realm")
            }
        } catch {
            return Observable<Bool>.just(false)
        }
        
        return Observable<Bool>.just(true) // all good here
        
    }
    
}
