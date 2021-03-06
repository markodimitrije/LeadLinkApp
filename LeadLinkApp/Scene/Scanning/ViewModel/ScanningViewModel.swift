//
//  ScanningViewModel.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 13/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

class ScanningViewModel {
    
    private (set) var obsCampaign: Observable<CampaignProtocol>
    private (set) var codesDataStore: CodesDataStore
    private (set) var logo: UIImage?
    
    public let codeInput = BehaviorSubject<String>(value: "")
    private var showDisclaimerValidator: ShowDisclaimerValidatorProtocol!
    
    private (set) var campaign: CampaignProtocol! {
        didSet {
            updateLogoImage()
            setCodeListener()
            self.showDisclaimerValidator = ShowDisclaimerValidator(campaign: campaign)
        }
    }

    init(obsCampaign: Observable<CampaignProtocol>, codesDataStore: CodesDataStore) {
        self.obsCampaign = obsCampaign
        self.codesDataStore = codesDataStore
        hookUpObserverToStateVar()
    }
    
    private func hookUpObserverToStateVar() {
        obsCampaign
        .subscribe(onNext: { campaign in
            self.campaign = campaign
        })
        .disposed(by: disposeBag)
    }
    
    private func updateLogoImage() {
        self.logo = UIImage.imageFromData(data: campaign.imgData) ?? UIImage.campaignPlaceholder
    }
    
    private func setCodeListener() {
        codeInput.debounce(0.5, scheduler: MainScheduler.instance) // jako vazno, da nema conflict na write u realm
        .subscribe(onNext: { code in
            guard code != "" else {return}
            let myCode = Code.init(value: code, campaign_id: self.campaign.id)
            _ = self.codesDataStore.save(code: myCode) // hard-coded, report to webApi
            // u stvari treba da dobacis sledecem a da on fetch answers i kasnije ih save za ovaj code
        }).disposed(by: disposeBag)
    }
    private let disposeBag = DisposeBag()
     
}
