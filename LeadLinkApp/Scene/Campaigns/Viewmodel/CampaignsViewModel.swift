//
//  CampaignsViewModel.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 04/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import RealmSwift
import RxSwift
import RxRealm
import PromiseKit

public class CampaignsViewModel {
    
    // MARK: - Properties
    let campaignsRepository: CampaignsRepository
    let downloadImageAPI: DownloadImageAPI
    
    private(set) var campaigns: Results<RealmCampaign>!
    
    // output
    
    private(set) var oCampaigns: Observable<(AnyRealmCollection<RealmCampaign>, RealmChangeset?)>!
    
    var selectedCampaign = BehaviorSubject<RealmCampaign?>.init(value: nil)
    
    // MARK: - Methods
    public init(campaignsRepository: CampaignsRepository, downloadImageAPI: DownloadImageAPI) {
        self.campaignsRepository = campaignsRepository
        self.downloadImageAPI = downloadImageAPI
        bindOutput()
    }
    
    @objc // zasto si zvao odavde ? verovatno treba da je matod pod repository
    public func getCampaignsFromWeb() { // neko ti trazi da download-ujes i persist...
        
        guard let userSession = campaignsRepository.userSessionRepository.readUserSession().value else {
            return
        }
        
        
        
        firstly { // TODO: just line below + catch + err handler ?
            
            campaignsRepository.getCampaignsAndQuestions(userSession: userSession)
            
        }
        .catch { (err) in
            guard let err = err as? CampaignError else {return}
            if err == .dontNeedUpdate {
                return
            }
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
    
    private let disposeBag = DisposeBag()
    
    private func handleErrorUsingAlert(err: Error) {
        var alertInfo: AlertInfo!
        
        if err == CampaignError.dontNeedUpdate { return }
        
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
