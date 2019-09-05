//
//  GlobalVars.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 10/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift

let kScanditBarcodeScannerAppKey: String = "AUe8bIKBFoCzJJPPuiOofAM5I9owLyf0rlrGJZhQ4LInWPIVz3VonUBir7VPXdyz4h8215sLK5dVPPhCIEV6A99KUPVsfXzQfy3w9wxVlWfFRgpOaUdH+XZlMQCuAEm1Th4eu8oxKt/6x0pVplemi4IzgCa4NYURqj2bXsWKR5/PaCIcmCZIYqGj8N4DUxA853PeccM7SeMhuUnuchIjzEyCZF8BThoEEqVty7e+SVPD4jBLOBbKvn59J0Goxy3tXOqIEI+jSL5bMXSBG1AdcJrFiLE4iVTAlP9jxaTD8SxspGhbEZXdSXFFNsHfrWRZQ7usbZNQmFjcWxjGCJ9WHqMtEXxRkx5jFiDWX98ZI2cOzNAT2AgquF62Ey6cXYT0nXupoIEnCgCDPx2HeHCCjI2yAaWPwnl2PJF4iQxz8VZHzSQiaJjl0udHnL0rneb0H9lqMVHEXiemwrBIBseFsQ71bNh611ukEqDI3nIFtBEX8ZJ6jmxYqMWtBcD+0mLeE3PoUbcHyJwzjTOJx66QJdj/vIb0NsTc8e6nzsh5UrHXtbq9Wtuki6vldYx5t1JHOZOX0458xybrnfKxBzp7s3CSA3o3AD8RZfY3SWvxcrOsA7fo68bSz5FkMLnsu/FDplihfPRRJoWSDs80ySLmlau6leNkyLXK11CzOZ9O67U80vefk8BAXOVpFLK0NwSE+360G6Hq8gOhseXeCgSLAsIFvCRWcUtalnDF3t9cRK6wMeywBULSzk553ZWwjUDrvIlq7TO5SqM7hHZ9jLcijZyxzU6wOm5H9gNxfRbXgP4ZeDVTtM6sLQ=="

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

