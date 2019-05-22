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

struct RealmDataPersister {
    
    static var shared = RealmDataPersister()
    
    // observable OUTPUT
    
    //func getRealmWebReportedCodes() -> Observable<Results<RealmWebReportedAnswers>> {
    func getRealmWebReportedAnswers() -> Observable<Results<RealmWebReportedAnswers>> {
        
        guard let realm = try? Realm.init() else {return Observable.empty()} // iako je Error!
        
        let results = realm.objects(RealmWebReportedAnswers.self)
        
        return Observable.collection(from: results) // this is live source !!
        
    }

    // MARK:- CodeReports
    
    func getReportsCount() -> Observable<Int> {
        
        guard let realm = try? Realm.init() else {return Observable.empty()} // iako je Error!
        
        let count = realm.objects(RealmWebReportedAnswers.self).count
        
        return Observable.just(count)
        
    }
    
    func getReports() -> [AnswersReport] {
        
        guard let realm = try? Realm.init() else {return [ ]} // iako je Error!
        
        let realmResults = realm.objects(RealmWebReportedAnswers.self).toArray()
        
        return realmResults.map {AnswersReport.init(realmAnswersReport: $0)}
        
    }
    
    func deleteAllAnswersReports() -> Observable<Bool> {
        
        guard let realm = try? Realm.init() else {
            return Observable.just(false)
        } // iako je Error!
        
        let realmResults = realm.objects(RealmWebReportedAnswers.self)
        
        do {
            try realm.write {
                realm.delete(realmResults)
            }
//            print("RealmDataPersister.deleteAllAnswersReports.all code reports are deleted")
            return Observable.just(true)
        } catch {
            return Observable.just(false)
        }
        
    }
    
    func deleteAnswersReports(_ reports: [AnswersReport]) -> Observable<Bool> {
        
        guard let realm = try? Realm.init() else {
            return Observable.just(false)
        } // iako je Error!
        
        let realmResults = realm.objects(RealmWebReportedAnswers.self).filter { report -> Bool in
            return reports.map {$0.code}.contains(report.code)
        }
        
        do {
            try realm.write {
                realm.delete(realmResults)
            }
            print("RealmDataPersister.deleteAnswersReports: delete Reported AnswersReports")
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
                realm.add(objects)
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
        
        if realm.objects(RealmWebReportedAnswers.self).filter("code = %@ && campaignId = %@", newReport.code, newReport.campaignId).isEmpty {
            
            do { // ako nemas ovaj objekat kod sebe u bazi
                
                try realm.write {
                    realm.add(newReport)
                    print("\(newReport.code), \(newReport.campaignId) saved to realm")
                }
            } catch {
                return Observable<Bool>.just(false)
            }
        
        } else {
            print("saveToRealm.objekat, code = \(newReport.code), \(newReport.campaignId) vec postoji u bazi")
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
