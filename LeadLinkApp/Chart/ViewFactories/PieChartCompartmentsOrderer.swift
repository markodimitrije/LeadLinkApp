//
//  PieChartCompartmentsOrderer.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 11/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

class PieChartCompartmentsOrderer {
    
    var compartments: [SingleCompartment]
    
    init(compartments: [SingleCompartment]) {
        
        var myOrderCompartments = [SingleCompartment?]()
        
        myOrderCompartments.append(compartments.first(where: {$0 is SyncedThisDeviceCompartmentInfo}))
        myOrderCompartments.append(compartments.first(where: {$0 is NotSyncedThisDeviceCompartmentInfo}))
        myOrderCompartments.append(compartments.first(where: {$0 is TotalOtherDevicesCompartmentInfo}))
        
        self.compartments = myOrderCompartments.compactMap({ $0 })
        
    }
    
}
