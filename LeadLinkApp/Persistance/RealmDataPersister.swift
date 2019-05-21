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
    
    func getRealmWebReportedCodes() -> Observable<Results<RealmWebReportedAnswers>> {
        
        guard let realm = try? Realm.init() else {return Observable.empty()} // iako je Error!
        
        let results = realm.objects(RealmWebReportedAnswers.self)
        
        return Observable.collection(from: results) // this is live source !!
        
    }

    // MARK:- CodeReports
    
    func getCodeReportsCount() -> Observable<Int> {
        
        guard let realm = try? Realm.init() else {return Observable.empty()} // iako je Error!
        
        let count = realm.objects(RealmWebReportedAnswers.self).count
        
        return Observable.just(count)
        
    }
    
    func getCodeReports() -> [AnswersReport] {
        
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
    
    func deleteAnswersReports(_ codeReports: [AnswersReport]) -> Observable<Bool> {
        
        guard let realm = try? Realm.init() else {
            return Observable.just(false)
        } // iako je Error!
        
        let realmResults = realm.objects(RealmWebReportedAnswers.self).filter { report -> Bool in
            return codeReports.map {$0.code}.contains(report.code)
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
        
        //let newCodeReport = RealmCodeReport.create(with: codeReport)
        let id = "\(report.campaignId)" + report.code
        let newCodeReport = RealmWebReportedAnswers.create(report: report)
        
        if realm.objects(RealmWebReportedAnswers.self).filter("code = %@ && campaignId = %@", newCodeReport.code, newCodeReport.campaignId).isEmpty {
            
            do { // ako nemas ovaj objekat kod sebe u bazi
                
                try realm.write {
                    realm.add(newCodeReport)
                    print("\(newCodeReport.code), \(newCodeReport.campaignId) saved to realm")
                }
            } catch {
                return Observable<Bool>.just(false)
            }
        
        } else {
            print("saveToRealm.objekat, code = \(newCodeReport.code), \(newCodeReport.campaignId) vec postoji u bazi")
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
    func save(codesAcceptedFromWeb: [AnswersReport]) -> Observable<Bool> {

        guard let realm = try? Realm() else {
            return Observable<Bool>.just(false) // treba da imas err za Realm...
        }

        //let firstAvailableId = realm.objects(RealmWebReportedAnswers.self).count
        let realmWebReportedCodes = codesAcceptedFromWeb.enumerated().map { (offset, codeReport) -> RealmWebReportedAnswers in
            let record = RealmWebReportedAnswers.create(report: codeReport)
            return record
        }

        do {
            try realm.write {
                realm.add(realmWebReportedCodes)
                print("total count of realmWebReportedCodes = \(realmWebReportedCodes.count), saved to realm")
            }
        } catch {
            return Observable<Bool>.just(false)
        }
        
        return Observable<Bool>.just(true) // all good here
        
    }
    
}
