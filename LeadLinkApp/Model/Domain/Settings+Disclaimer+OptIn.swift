//
//  Settings.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 22/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

public struct Settings: Codable {
    var disclaimer: Disclaimer
    var optIn: OptIn
    
    init(realmSettings settings: RealmSettings?) {
        self.disclaimer = Disclaimer.init(realmDisclaimer: settings?.disclaimer)
        self.optIn = OptIn(realmOptIn: settings?.optIn)
    }
}

public struct Disclaimer: Codable {
    var text: String
    var url: String
    
    init(realmDisclaimer disclaimer: RealmDisclaimer?) {
        self.text = disclaimer?.text ?? ""
        self.url = disclaimer?.url ?? ""
    }
}

public struct OptIn: Codable {
    var text: String
    var url: String
    
    init(realmOptIn optIn: RealmOptIn?) {
        self.text = optIn?.text ?? ""
        self.url = optIn?.url ?? ""
    }
}
