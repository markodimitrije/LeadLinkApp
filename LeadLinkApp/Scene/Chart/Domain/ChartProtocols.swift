//
//  ChartProtocols.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 08/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

// Diagram + GridTable protocols

protocol BarOrChartDiagram {
    var compartments: [SingleCompartmentProtocol] {get set}
}

protocol BarOrChartTable {
    var compartments: [SingleCompartmentProtocol] {get set}
    var date: Date {get set}
}


