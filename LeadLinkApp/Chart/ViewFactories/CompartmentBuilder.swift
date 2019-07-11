//
//  CompartmentBuilder.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 11/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

class CompartmentBuilder: BarOrChartCompartmentsInfo {
    
    var compartments: [SingleCompartment]
    
    init(barOrChartInfo: BarOrChartInfo) {
        
        let totalOtherDevicesCompartmentInfo =
            TotalOtherDevicesCompartmentInfo(value: barOrChartInfo.compartmentValues[0])
        
        let syncedThisDeviceCompartmentInfo =
            SyncedThisDeviceCompartmentInfo(value: barOrChartInfo.compartmentValues[1])
        
        let notSyncedThisDeviceCompartmentInfo = NotSyncedThisDeviceCompartmentInfo(value:barOrChartInfo.compartmentValues[2])
        
        self.compartments = [totalOtherDevicesCompartmentInfo,
                             syncedThisDeviceCompartmentInfo,
                             notSyncedThisDeviceCompartmentInfo]
        
    }
}
