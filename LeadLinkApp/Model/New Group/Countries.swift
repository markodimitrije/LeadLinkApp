//
//  Countries.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 06/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct CountriesManager {
    var countries = [String: String]()
    init() {
        countries = countriesDict
    }
    
    private let countriesDict = ["1": "AFGHANISTAN",
                                 "2": "ALAND ISLANDS",
                                 "3": "ALBANIA",
                                 "4": "ALGERIA"]
}


