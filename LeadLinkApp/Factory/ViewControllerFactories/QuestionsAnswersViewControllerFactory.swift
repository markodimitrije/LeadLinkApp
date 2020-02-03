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
    private var campaignsDataStore: CampaignsDataStore {
        return appDependancyContainer.sharedCampaignsRepository.dataStore
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
        }
        
        surveyInfo = SurveyInfo.init(campaign: campaign, code: code, hasConsent: consent)
        
        let vc = QuestionsAnswersVC.instantiate(using: appDependancyContainer.sb)
        
        let viewmodelFactory = QuestionsAnswersViewModelFactory()
        let qaViewmodel = viewmodelFactory.make(surveyInfo: surveyInfo!,
                                                obsDelegate: Observable.just(delegate))
        
        vc.surveyInfo = surveyInfo
        vc.viewModel = qaViewmodel
        
        return vc
    }
    
    func makeVC(codeValue: String, campaignId: Int) -> QuestionsAnswersVC {
        
        guard let campaign = campaignsDataStore.readCampaign(id: campaignId).value else {
            fatalError("no campaign value !?!")
        }
        
        surveyInfo = SurveyInfo.init(campaign: campaign, code: codeValue)
        
        let vc = QuestionsAnswersVC.instantiate(using: appDependancyContainer.sb)
        
        let viewmodelFactory = QuestionsAnswersViewModelFactory()
        let qaViewmodel = viewmodelFactory.make(surveyInfo: surveyInfo!,
                                                obsDelegate: Observable.just(nil))
        
        vc.viewModel = qaViewmodel
        vc.surveyInfo = surveyInfo
        
        return vc
    }

}


