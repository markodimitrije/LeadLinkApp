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
}
