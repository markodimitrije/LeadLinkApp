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
import Realm
import RxRealm

struct AnswersReportDataStore {
    
    static var shared = AnswersReportDataStore()
    
    // observable OUTPUT
    
    func getRealmWebReportedAnswers() -> Observable<[RealmWebReportedAnswers]> {
        
        guard let realm = try? Realm.init() else {return Observable.empty()} // iako je Error!
        
        let results = realm.objects(RealmWebReportedAnswers.self)
        
        return Observable
            .collection(from: results) // this is live source !!
            .map {$0.toArray()}
    }

    // MARK:- Reports
    
    func getReports() -> [AnswersReport] {
        
        guard let realm = try? Realm.init() else {return [ ]} // iako je Error!
        
        let realmResults = realm.objects(RealmWebReportedAnswers.self).toArray()
        
        return realmResults.map {AnswersReport.init(realmAnswersReport: $0)}
        
    }
    
    func getFailedReports() -> [AnswersReport] {
        
        let all = getReports()
        return all.filter {$0.success == false}
        
    }
    
    func updateReports(_ reports: [AnswersReport]) -> Observable<Bool> {
        
        guard let realm = try? Realm.init() else {
            return Observable.just(false)
        } // iako je Error!
        
        let records = reports.map {RealmWebReportedAnswers.create(report: $0)}
        
        do {
            try realm.write {
                realm.add(records, update: true)
            }
            print("RealmDataPersister.deleteAnswersReports: update Reported AnswersReports")
            return Observable.just(true)
        } catch {
            return Observable.just(false)
        }
        
    }
    
    // MARK:- Save data
    
    func saveToRealm<T: Object>(objects: [T]) -> Observable<Bool> {
        
        guard let realm = try? Realm() else {
            return Observable<Bool>.just(false) // treba da imas err za Realm...
        }
        
        do {
            try realm.write {
                realm.add(objects, update: true)
            }
        } catch {
            return Observable<Bool>.just(false)
        }
        
        return Observable<Bool>.just(true) // all good here
        
    }
    
    func saveToRealm(report: AnswersReport) -> Observable<Bool> {
        
        guard let realm = try? Realm() else {
            return Observable<Bool>.just(false) // treba da imas err za Realm...
        }
        
        let newReport = RealmWebReportedAnswers.create(report: report)

        do { // ako nemas ovaj objekat kod sebe u bazi
            
            try realm.write {
                realm.add(newReport, update: true)
                print("\(newReport.code), \(newReport.campaignId), \(newReport.success), saved to realm")
            }
        } catch {
            return Observable<Bool>.just(false)
        }
        
        return Observable<Bool>.just(true) // all good here
        
    }
    
    // MARK: All data (delete)
    
    func deleteAllDataIfAny() -> Observable<Bool> {
        guard let realm = try? Realm() else {
            return Observable<Bool>.just(false) // treba da imas err za Realm...
        }
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            return Observable<Bool>.just(false) // treba da imas err za Realm...
        }
        return Observable<Bool>.just(true) // all good
    }
    
    func deleteAllObjects<T: Object>(ofTypes types: [T.Type]) -> Observable<Bool> {
        guard let realm = try? Realm() else {
            return Observable<Bool>.just(false) // treba da imas err za Realm...
        }
        do {
            try realm.write {
                for type in types {
                    let objects = realm.objects(type)
                    realm.delete(objects)
                }
            }
        } catch {
            return Observable<Bool>.just(false) // treba da imas err za Realm...
        }
        return Observable<Bool>.just(true) // all good
    }
    
    // MARK: save codes successfully reported to web
    func save(reportsAcceptedFromWeb reports: [AnswersReport]) -> Observable<Bool> {

        guard let realm = try? Realm() else {
            return Observable<Bool>.just(false) // treba da imas err za Realm...
        }

        let realmWebReportedCodes = reports.enumerated().map { (offset, report) -> RealmWebReportedAnswers in
            let record = RealmWebReportedAnswers.create(report: report)
            return record
        }

        do {
            try realm.write {
                realm.add(realmWebReportedCodes, update: true)
                print("total count of realmWebReportedCodes = \(realmWebReportedCodes.count), saved to realm")
            }
        } catch {
            return Observable<Bool>.just(false)
        }
        
        return Observable<Bool>.just(true) // all good here
        
    }
    
}
