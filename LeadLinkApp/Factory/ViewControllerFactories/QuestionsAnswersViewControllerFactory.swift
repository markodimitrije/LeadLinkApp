//
//  QuestionsAnswersViewControllerFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 21/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

class QuestionsAnswersViewControllerFactory {
    
    private var appDependancyContainer: AppDependencyContainer
    private var campaignsDataStore: CampaignsDataStore {
        return appDependancyContainer.sharedCampaignsRepository.dataStore
    }
    
    init(appDependancyContainer: AppDependencyContainer) {
        self.appDependancyContainer = appDependancyContainer
    }
    
    func makeVC(scanningViewModel viewModel: ScanningViewModel?,
                hasConsent consent: Bool = false) -> QuestionsAnswersVC {
        
        guard let code = try? viewModel!.codeInput.value() else {fatalError()}
        
        guard let campaignId = UserDefaults.standard.value(forKey: "campaignId") as? Int else {
            fatalError("no campaign selected !?!")
        }
        
        guard let campaign = campaignsDataStore.readCampaign(id: campaignId).value else {
            fatalError("no campaign value !?!")
        }
        
        let surveyInfo = SurveyInfo.init(campaign: campaign , code: code, hasConsent: consent)
        
        let vc = QuestionsAnswersVC.instantiate(using: appDependancyContainer.sb)
        
        vc.surveyInfo = surveyInfo
        
        return vc
    }
    
    func makeVC(code: Code) -> QuestionsAnswersVC {
        
        let codeValue = code.value
        
        let campaignId = code.campaign_id
        
        guard let campaign = campaignsDataStore.readCampaign(id: campaignId).value else {fatalError("no campaign value !?!")}
        
        let surveyInfo = SurveyInfo.init(campaign: campaign, code: codeValue)
        
        let vc = QuestionsAnswersVC.instantiate(using: appDependancyContainer.sb)
        
        vc.surveyInfo = surveyInfo
        
        return vc
    }
    
    func makeVC(codeValue: String, campaignId: Int) -> QuestionsAnswersVC {
        
        guard let campaign = campaignsDataStore.readCampaign(id: campaignId).value else {
            fatalError("no campaign value !?!")
        }
        
        let surveyInfo = SurveyInfo.init(campaign: campaign, code: codeValue)
        
        let vc = QuestionsAnswersVC.instantiate(using: appDependancyContainer.sb)
        
        vc.surveyInfo = surveyInfo
        
        return vc
    }

}


