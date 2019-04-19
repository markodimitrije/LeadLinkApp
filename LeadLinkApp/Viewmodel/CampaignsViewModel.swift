//
//  CampaignsViewModel.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 04/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

//import Foundation
//import RxSwift

import Foundation
import RealmSwift
import Realm
import RxSwift
import RxRealm

import PromiseKit

public class CampaignsViewModel {
    
    // MARK: - Properties
    let campaignsRepository: CampaignsRepository
    
    // MARK: - Methods
    public init(campaignsRepository: CampaignsRepository) {
        self.campaignsRepository = campaignsRepository
        bindOutput()
    }
    
    @objc // zasto si zvao odavde ? verovatno treba da je matod pod repository
    public func getCampaignsFromWeb() { // neko ti trazi da download-ujes i persist...
        
        guard let userSession = campaignsRepository.userSessionRepository.readUserSession().value else {
            return
        }
        
        firstly {
            
            campaignsRepository.getCampaignsAndQuestions(userSession: userSession)//userSession)
            
        }.then { success -> Promise<[LogoInfo]> in
            
            if success {
                return self.campaignsRepository.dataStore.readAllCampaignLogoInfos()
            } else {
                return Promise<[LogoInfo]>.init(resolver: { (seal) in
                    seal.reject(CampaignError.dontNeedUpdate)
                })
            }
            
        }.thenMap { logoInfo -> Promise<LogoInfo> in

            let dataPromise = self.campaignsRepository.remoteAPI.getImage(url: logoInfo.url ?? "")

            return dataPromise.map { (data) -> LogoInfo in

                return LogoInfo.init(id: logoInfo.id, url: logoInfo.url, imgData: data)
            }

        }.done { (infos) in     //       print("imam logo infos")
            let _ = infos.map {
                RealmCampaign.updateImg(data: $0.imgData, campaignId: $0.id)
            }
        }.catch { (err) in
            print("err or status = \(err)")
        }
    
    }
    
    private(set) var campaigns: Results<RealmCampaign>!
    
    // input
    var selectedTableIndex: BehaviorSubject<Int?> = BehaviorSubject.init(value: 0)
    
    // output
    
    private(set) var oCampaigns: Observable<(AnyRealmCollection<RealmCampaign>, RealmChangeset?)>!
    
    var selectedCampaign = BehaviorSubject<RealmCampaign?>.init(value: nil)
    
    // MARK:- calculators
    
    func getCampaign(forSelectedTableIndex index: Int) -> RealmCampaign {
        // mogao si check za index i rooms.count -> RealmCampaign?
        return campaigns[index]
    }
    
    // MARK:- Private methods
    
    private func bindOutput() { // hook-up se za Realm, sada su Rooms synced sa bazom
        
        guard let realm = try? Realm() else { return }
        
        campaigns = realm.objects(RealmCampaign.self)
        
        oCampaigns = Observable.changeset(from: campaigns)
        
        selectedTableIndex.subscribe(onNext: { index in
            print("selectedTableIndex je dobio index = \(index)")
            let campaigns = self.campaigns.toArray()
            if let index = index, index < campaigns.count {
                print("da li je ikada emitovao index >!>>! = \(index)")
                self.selectedCampaign.onNext(campaigns[index])
            }
        }).disposed(by: disposeBag)
        
    }
    
    private let disposeBag = DisposeBag()
   
}
