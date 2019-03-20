//
//  ScanningViewModel.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 13/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

// treba da zna da prikaze logo kampanje (dobija data preko selected Campaign, javice ti campaignsVC)

import UIKit
import RxSwift

class ScanningViewModel {
    
    var campaign: Campaign
    var codesDataStore: CodesDataStore
    var logo: UIImage?
    public let codeInput = BehaviorSubject<String>(value: "")

    init(campaign: Campaign, codesDataStore: CodesDataStore) {
        self.campaign = campaign
        self.codesDataStore = codesDataStore
        updateLogoImage(campaign: campaign)
        setCodeListener()
    }
    
    init(realmCampaign: RealmCampaign, codesDataStore: CodesDataStore) {
        self.campaign = Campaign.init(realmCampaign: realmCampaign)
        self.codesDataStore = codesDataStore
        updateLogoImage(campaign: campaign)
        setCodeListener()
    }
    
    private func updateLogoImage(realmCampaign: RealmCampaign) {
        self.logo = UIImage.imageFromData(data: realmCampaign.imgData) ?? UIImage.campaignPlaceholder
    }
    private func updateLogoImage(campaign: Campaign) {
        self.logo = UIImage.imageFromData(data: campaign.imgData) ?? UIImage.campaignPlaceholder
    }
    private func setCodeListener() {
        codeInput.subscribe(onNext: { code in
            print("ScanningViewModel. code is = \(code), forward to dataProvider campaign = \(self.campaign)")
            let myCode = Code.init(value: code, campaign_id: self.campaign.id)
            _ = self.codesDataStore.save(code: myCode) // hard-coded, report to webApi
            // u stvari treba da dobacis sledecem a da on fetch answers i kasnije ih save za ovaj code
        }).disposed(by: disposeBag)
    }
    private let disposeBag = DisposeBag()
    
}
