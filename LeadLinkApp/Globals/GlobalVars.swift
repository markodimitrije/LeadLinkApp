//
//  GlobalVars.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 10/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift

let factory: AppDependencyContainer = AppDependencyContainer.init()

var reportsDumperWorker: ReportsDumperWorkerProtocol! // prazni codes (saved in Realm), koji su failed da se prijave pojedinacno na web

var tableHeaderFooterCalculator: QuestionsAnswersTableViewHeaderFooterCalculating {
    
    guard let deviceType = getDeviceType() else { fatalError("cant determine device type!?!") }
    
    switch deviceType {
    case DeviceType.iPhone: return IphoneQuestionsAnswersTableViewHeaderFooterCalculator()
    case DeviceType.iPad: return IpadQuestionsAnswersTableViewHeaderFooterCalculator()
    }
}

//var confApiKeyState = ConferenceApiKeyState()
var confApiKeyState: ConferenceApiKeyState? = {
    
    let authToken = UserDefaults.standard.value(forKey: UserDefaults.keyConferenceAuth) as? String ?? ""
    var selectedCampaign: CampaignProtocol?
    
    if let campaignId = UserDefaults.standard.value(forKey: UserDefaults.keyConferenceId) as? Int {
        let sharedCampaignsRepository = factory.campaignsImmutableRepo.readCampaign(id: campaignId)
            .done { campaign in
                selectedCampaign = campaign
        }
    }
    return ConferenceApiKeyState(authToken: authToken, selectedCampaign: selectedCampaign)
}()

var selectedCampaignId: Int? {
    get {
        return UserDefaults.standard.value(forKey: "campaignId") as? Int
    }
    set {
        UserDefaults.standard.setValue(newValue, forKey: "campaignId")
    }
}

var allowedQuestionsWidth: CGFloat {
    guard let deviceType = getDeviceType() else {return 0.0} // fatal..
    if deviceType == .iPad {
        return UIScreen.main.bounds.width/2 - 16
    } else if deviceType == .iPhone {
        return UIScreen.main.bounds.width - 16
    }
    fatalError("not itended to work on other device type..")
}
