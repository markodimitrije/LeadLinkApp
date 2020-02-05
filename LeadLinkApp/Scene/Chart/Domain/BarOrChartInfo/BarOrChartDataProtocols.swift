//
//  BarOrChartDataProtocols.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 09/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol BarOrChartInfoProtocol {
    var compartmentValues: [Int] {get set}
}

protocol BarOrChartCompartmentsProtocol {
    var compartments: [SingleCompartment] {get set}
}
