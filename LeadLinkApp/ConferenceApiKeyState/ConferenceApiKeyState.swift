//
//  File.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 06/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

class ConferenceApiKeyState: ConfIdApiKeyAuthSupplying {
    
    var conferenceId: Int? {
        get {
            return UserDefaults.standard.value(forKey: UserDefaults.keyConferenceId) as? Int
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.keyConferenceId)
        }
    }
    var apiKey: String? {
        get {
            return UserDefaults.standard.value(forKey: UserDefaults.keyConferenceApiKey) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.keyConferenceApiKey)
        }
    }
    var authentication: String? {
        get {
            return UserDefaults.standard.value(forKey: UserDefaults.keyConferenceAuth) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.keyConferenceAuth)
        }
    }
    
    init() {
        // medibeacon
        if UserDefaults.standard.value(forKey: UserDefaults.keyConferenceApiKey) == nil {
            UserDefaults.standard.set("LLNOQ8IBXTbKnSSGZ6YZOIFA1Qk4lS01", forKey: UserDefaults.keyConferenceApiKey)
        }
        if UserDefaults.standard.value(forKey: UserDefaults.keyConferenceId) == nil {
            UserDefaults.standard.set(7520, forKey: UserDefaults.keyConferenceId)
        }
        
    }
    
}
