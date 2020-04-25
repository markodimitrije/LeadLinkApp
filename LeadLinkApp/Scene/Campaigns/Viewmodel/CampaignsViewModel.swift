//
//  CampaignsViewModel.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 04/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RealmSwift
import RxRealm
import RxSwift
import PromiseKit

class CampaignsViewModel {
    
    // MARK: - Properties
    private let campaignsWorker: ICampaignsWorker
    private let disposeBag = DisposeBag()
    
    private(set) var campaigns: Results<RealmCampaign>!
    private(set) var oCampaigns: Observable<(AnyRealmCollection<RealmCampaign>, RealmChangeset?)>!
    var selectedCampaign = BehaviorSubject<RealmCampaign?>.init(value: nil)
    
    // MARK: - Methods
    init(campaignsWorker: ICampaignsWorker) {
        self.campaignsWorker = campaignsWorker
        bindOutput()
    }
    
    func getCampaignsFromWeb() { // neko ti trazi da download-ujes i persist...
        
        self.campaignsWorker
            .getCampaignsAndQuestions()
            .catch { (err) in
            guard let err = err as? CampaignError else {return}
            self.handleErrorUsingAlert(err: err)
            _ = factory.sharedUserSessionRepository.signOut(userSession: factory.sharedUserSessionRepository.readUserSession().value!)
            RealmCampaignsDataStore().deleteCampaignRelatedData()
        }
    
    }
    
    // MARK:- calculators
    
    func getCampaign(forSelectedTableIndex index: Int) -> Campaign {
        // mogao si check za index i rooms.count -> RealmCampaign?
        return Campaign(realmCampaign: campaigns[index])
    }
    
    // MARK:- Private methods
    
    private func bindOutput() { // hook-up se za Realm, sada su Rooms synced sa bazom
        
        guard let realm = try? Realm() else { return }
        
        campaigns = realm.objects(RealmCampaign.self)
        
        oCampaigns = Observable.changeset(from: campaigns)
        
    }
    
    private func handleErrorUsingAlert(err: Error) {
        var alertInfo: AlertInfo!
        
        if err == CampaignError.noCampaignsFound {
            alertInfo = AlertInfo.getInfo(type: AlertInfoType.noCampaigns)
        } else if err == CampaignError.mandatoryKeyIsMissing {
            alertInfo = AlertInfo.getInfo(type: AlertInfoType.campaignKeyIsMissing)
        } else {
            let title = NSLocalizedString("Strings.Campaign.Err.campaignError", comment: "")
            let text = err.localizedDescription + NSLocalizedString("Strings.Campaign.Err.contactNavusTeam", comment: "")
            
            alertInfo = AlertInfo.init(title: title, text: text, btnText: ["OK"])
        }
        
        if let topVC = UIApplication.topViewController() {
            topVC.alert(alertInfo: alertInfo, preferredStyle: .alert)
                .subscribe { _ in
                (UIApplication.shared.delegate as! AppDelegate).loadLoginVC()
            }//.disposed(by: disposeBag)
        }
    }
   
}
