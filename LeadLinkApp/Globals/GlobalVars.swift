//
//  GlobalVars.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 10/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift

let kScanditBarcodeScannerAppKey: String = "AfqNPNOBRz84MGjA1BBW7tg0GJdPLM/zOEgApKQl3B9UO4ET0l6lWNZjiW84d3BVt11hIVllZ8pfTbH+BH+DcSZeJscvd5+F6ViWq6hIUQ27WWbb7GC+ziRDHoP+BLpsBj8mFd0dvR3PBYEEVFIhStJZyIVCJncN5l0cUn4g/g9HFfWBMHIdpke8FUYOpQwhcqMDSalzhsYjiKDbHUeedFw73t0+73YOGjlVzj7qGJ4tNZrYgaN+w2LxP8eooc42YK5ak0tzVF5CcOI32j/6SJxV1oFvZwN6+Ojim6lLEjSZ+ktDvMcij6Gwaa4wXbeRVXDGGKQyIqsfcUOjinGXMFyMLcvlAk9y2TNQvobu0Auj/alB+1+eSCsrBoSnMiCNtdbVSG8rb7TmJQX/kLs3hkvz780WGTRVb6XO3QKLciLEEGRTnNBn3FTDhg5hB/eswDLO/V3FypaP51f9koqVlxh9W9U+wUiF7Ik8lww/j/L401Jol0ouaMgMSuGPglqjITTBlfU0FaiCcrTeG2oUA/4eIz82x7Yi+p+2DdXOE7e/OAzexWebAP/5rVOr9bQ6doGQPc0a+KMvvxABS2jM+6fz01Ddi4O9zlJ75hc5K2zsBflCWkGpiLH/qzgJJy/mti1cE1PAJ7atmhhunIkGhfKQcXdY22L2p41SySynmQTHxHaRmV2LyPteYBE5gE2HzcGeTYeuos7UrIoD7mBGgswT6mBYWlgGqLbqTWVKlY88IWhfEEfMVXsiw1xpl5fYBioBJ3H87Oz6oTUTbc6MUdPpIj+dzUIjQzChpmsS9eLqNxmOB2L76UCr"

let factory: AppDependencyContainer = AppDependencyContainer.init()

var surveyInfo: SurveyInfo?

var tableRowHeightCalculator: QuestionsAnswersTableRowHeightCalculating = {

    guard let deviceType = getDeviceType() else { fatalError("cant determine device type!?!") }
    
    switch deviceType {
    case DeviceType.iPhone: return IphoneQuestionsAnswersTableRowHeightCalculator()
    case DeviceType.iPad: return IpadQuestionsAnswersTableRowHeightCalculator()
    }
}()

var tableHeaderFooterCalculator: QuestionsAnswersTableViewHeaderFooterCalculating {
    
    guard let deviceType = getDeviceType() else { fatalError("cant determine device type!?!") }
    
    switch deviceType {
    case DeviceType.iPhone: return IphoneQuestionsAnswersTableViewHeaderFooterCalculator()
    case DeviceType.iPad: return IpadQuestionsAnswersTableViewHeaderFooterCalculator()
    }
}

var reportsDumper: ReportsDumper! // prazni codes (saved in Realm), koji su failed da se prijave pojedinacno na web

//var confApiKeyState = ConferenceApiKeyState()
var confApiKeyState: ConferenceApiKeyState? = {
    
    let authToken = UserDefaults.standard.value(forKey: UserDefaults.keyConferenceAuth) as? String ?? ""
    var selectedCampaign: Campaign?
    
    if let campaignId = UserDefaults.standard.value(forKey: UserDefaults.keyConferenceId) as? Int {
        let sharedCampaignsRepository = factory.sharedCampaignsRepository
        sharedCampaignsRepository.dataStore.readCampaign(id: campaignId)
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
