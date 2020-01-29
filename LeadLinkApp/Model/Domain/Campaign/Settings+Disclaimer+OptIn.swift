//
//  Settings.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 22/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

public struct Settings: Codable {
    var disclaimer: Disclaimer?
    var optIn: OptIn?
    var use_scandit_scanner: Bool?
    var showEmail: Bool?
    
    init(realmSettings settings: RealmSettings?) {
        self.disclaimer = Disclaimer.init(realmDisclaimer: settings?.disclaimer)
        self.optIn = OptIn(realmOptIn: settings?.optIn)
        self.use_scandit_scanner = settings?.useScanditScanner
        self.showEmail = settings?.showEmail
    }
    
    init?(settingsResponse: SettingsResponseProtocol?) {
        guard let settingsResponse = settingsResponse else {
            return nil
        }
        self.use_scandit_scanner = settingsResponse.use_scandit_scanner
        self.showEmail = settingsResponse.showEmail
        self.disclaimer = Disclaimer(disclaimerResponse: settingsResponse.disclaimerResponse)
        self.optIn = OptIn(optInResponse: settingsResponse.optInResponse)
    }
}

public struct Disclaimer: Codable {
    var text: String
    var privacyPolicy: String
    var url: String
    
    init?(realmDisclaimer disclaimer: RealmDisclaimer?) {
        guard let text = disclaimer?.text, let url = disclaimer?.url, let privacyPolicy = disclaimer?.privacyPolicy else {
                return nil
        }
        self.text = text
        self.url = url
        self.privacyPolicy = privacyPolicy
    }
    
    init?(disclaimerResponse: DisclaimerResponseProtocol?) {
        guard let disclaimerResponse = disclaimerResponse else {
            return nil
        }
        self.text = disclaimerResponse.text
        self.privacyPolicy = disclaimerResponse.privacyPolicy
        self.url = disclaimerResponse.url
    }
}

public struct OptIn: Codable {
    var text: String
    var url: String
    var privacyPolicy: String
    
    init?(realmOptIn optIn: RealmOptIn?) {
        guard let optIn = optIn else {
            return nil
        }
        self.text = optIn.text
        self.url = optIn.url
        self.privacyPolicy = optIn.privacyPolicy
    }
    
    init?(optInResponse: OptInResponseProtocol?) {
        guard let optInResponse = optInResponse else {
            return nil
        }
        self.text = optInResponse.text
        self.privacyPolicy = optInResponse.privacyPolicy
        self.url = optInResponse.url
    }
}
