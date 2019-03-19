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
    var logo: UIImage?
    public let codeInput = BehaviorSubject<String>(value: "")
    
    init(campaign: Campaign) {
        self.campaign = campaign
        updateLogoImage(campaign: campaign)
        setCodeListener()
    }

    init(realmCampaign: RealmCampaign) {
        self.campaign = Campaign.init(realmCampaign: realmCampaign)
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
        codeInput.subscribe(onNext: { code in // print("code is = \(code)")
        }).disposed(by: disposeBag)
    }
    private let disposeBag = DisposeBag()
    
}
