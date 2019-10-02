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
    
    init(realmSettings settings: RealmSettings?) {
        self.disclaimer = Disclaimer.init(realmDisclaimer: settings?.disclaimer)
        self.optIn = OptIn(realmOptIn: settings?.optIn)
        self.use_scandit_scanner = settings?.useScanditScanner
    }
}

public struct Disclaimer: Codable {
    var text: String
    var url: String
    
    init?(realmDisclaimer disclaimer: RealmDisclaimer?) {
        guard let text = disclaimer?.text,
            let url = disclaimer?.url else {
                return nil
        }
        self.text = text
        self.url = url
    }
}

public struct OptIn: Codable {
    var text: String
    var url: String
    
    init?(realmOptIn optIn: RealmOptIn?) {
        guard let text = optIn?.text,
            let url = optIn?.url else {
                return nil
        }
        self.text = text
        self.url = url
    }
}
