//
//  QuestionsAnswersViewControllerFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 21/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift

class QuestionsAnswersViewControllerFactory {
    
    private var appDependancyContainer: AppDependencyContainer
    private var campaignsDataStore: ICampaignsImmutableRepository {
        return appDependancyContainer.campaignsImmutableRepo
    }
    
    init(appDependancyContainer: AppDependencyContainer) {
        self.appDependancyContainer = appDependancyContainer
    }
    
    func makeVC(scanningViewModel viewModel: ScanningViewModel?,
                hasConsent consent: Bool = false,
                delegate: Delegate?) -> QuestionsAnswersVC {
        
        guard let code = try? viewModel!.codeInput.value() else {fatalError()}
        
        guard let campaignId = selectedCampaignId,
            let campaign = campaignsDataStore.readCampaign(id: campaignId).value else {
            fatalError("no campaign selected or no campaign found !?!")
                // TODO: ima unsynced state, kampanje su updated ali je selektovana neka koja je u medjuvremenu obrisana na konfiguratoru -> alert + force logout
        }
        
        let vc = QuestionsAnswersVC.instantiate(using: appDependancyContainer.sb)
        
        let surveyInfo = SurveyInfo.init(campaign: campaign, code: code, hasConsent: consent)
        let viewmodel = QuestionsAnswersViewModelFactory().make(surveyInfo: surveyInfo,
                                                                delegate: delegate)
        vc.viewModel = viewmodel
        
        return vc
    }
    
    func makeVC(codeValue: String, campaignId: Int) -> QuestionsAnswersVC {
        
        guard let campaign = campaignsDataStore.readCampaign(id: campaignId).value else {
            fatalError("no campaign value !?!")
        }
        
        let vc = QuestionsAnswersVC.instantiate(using: appDependancyContainer.sb)
        
        let surveyInfo = SurveyInfo.init(campaign: campaign, code: codeValue)
        let viewmodel = QuestionsAnswersViewModelFactory().make(surveyInfo: surveyInfo, delegate: nil)
        vc.viewModel = viewmodel
        
        return vc
    }

}
