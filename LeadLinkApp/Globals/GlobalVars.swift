//
//  GlobalVars.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 10/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift

//let kScanditBarcodeScannerAppKey: String? =// nil
//"ASHdMpiBDE75BbkR4xSxe94Ezm55L9o9KH8QCJpnArp5YMw09nsx3WBp35/nLtAQzmSC0CJNnYphbuRJWnevrfoxs6hqIw0HNQBnWE5oezqEQ09DYlBPKwkgQgn+Ep4DiwLrV8oXC53SOeo9IuLiG1TWKlVVkgPeLkIdj36yzjk++ZXCyU2NpMieDq1bqtjufDwK1OxtorxerOyeE4ow4xI1h35YvQ7MlUaVrJPgjzqOXfFxbzokcCfPECvTequ5bblhOyAKn6bZrB0GLoAriPGJMXV0gauof1vMu7HSyLYvdqUfu+x7guuB6aO3Wv2nbYypK+EjuqHYfujLpKR+FNK6870HBdqYCetDVi88a4wEeO6oskUr+kudb6rgN/miXylATAWKWzZ7DlHmAAF6m4YSMjgRQYtWYoDblGqdOkmZlJwe3SwTKqhYan6F0Wvm3wafNcrQmFEjkFp2jD5aMC2Pz+LLicSXu+xavUega5BOXMLCpC9RBXx7Hxn3sD11IYUG3CCjD5Zcix10YDAzS8tscEdYru9CM6CdJNRMIKteR+nSOSRSPBG8fje0Tm+XT048+OPyZf6USMD1J+AzmBp6sixOS6u/n4+3gSL3FFhs3J6rRSoDBy5OMwSH6A5HT27vwSR5s4YX9yAl4dJde1RR5IxEIeAterd4PIpWJIJNMgQo65P3JYC1oVMtAImV25cE39JXeZvl+tY9bw4q9TLMMqZxjbg/4v4Ic4MwsQysFTjHN05NVw/gGhe4pOiif7/pJGOch4uNKUEWc0TcYUPXjcDaV2mv8oZXu65ciejO2txH"

let kScanditBarcodeScannerAppKey: String = "AUe8bIKBFoCzJJPPuiOofAM5I9owLyf0rlrGJZhQ4LInWPIVz3VonUBir7VPXdyz4h8215sLK5dVPPhCIEV6A99KUPVsfXzQfy3w9wxVlWfFRgpOaUdH+XZlMQCuAEm1Th4eu8oxKt/6x0pVplemi4IzgCa4NYURqj2bXsWKR5/PaCIcmCZIYqGj8N4DUxA853PeccM7SeMhuUnuchIjzEyCZF8BThoEEqVty7e+SVPD4jBLOBbKvn59J0Goxy3tXOqIEI+jSL5bMXSBG1AdcJrFiLE4iVTAlP9jxaTD8SxspGhbEZXdSXFFNsHfrWRZQ7usbZNQmFjcWxjGCJ9WHqMtEXxRkx5jFiDWX98ZI2cOzNAT2AgquF62Ey6cXYT0nXupoIEnCgCDPx2HeHCCjI2yAaWPwnl2PJF4iQxz8VZHzSQiaJjl0udHnL0rneb0H9lqMVHEXiemwrBIBseFsQ71bNh611ukEqDI3nIFtBEX8ZJ6jmxYqMWtBcD+0mLeE3PoUbcHyJwzjTOJx66QJdj/vIb0NsTc8e6nzsh5UrHXtbq9Wtuki6vldYx5t1JHOZOX0458xybrnfKxBzp7s3CSA3o3AD8RZfY3SWvxcrOsA7fo68bSz5FkMLnsu/FDplihfPRRJoWSDs80ySLmlau6leNkyLXK11CzOZ9O67U80vefk8BAXOVpFLK0NwSE+360G6Hq8gOhseXeCgSLAsIFvCRWcUtalnDF3t9cRK6wMeywBULSzk553ZWwjUDrvIlq7TO5SqM7hHZ9jLcijZyxzU6wOm5H9gNxfRbXgP4ZeDVTtM6sLQ=="

let factory = AppDependencyContainer.init()

var surveyInfo: SurveyInfo?

var tableRowHeightCalculator = QuestionsAnswersTableRowHeightCalculator()

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

