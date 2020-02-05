//
//  CompartmentBuilder.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 11/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct CompartmentBuilder: BarOrChartCompartmentsProtocol {
    
    var compartments: [SingleCompartment]
    
    init(barOrChartInfo: BarOrChartInfoProtocol) {

        // MOCK
//        let totalOtherDevicesCompartmentInfo =
//            TotalOtherDevicesCompartmentInfo(value: 100)
//
//        let syncedThisDeviceCompartmentInfo =
//            SyncedThisDeviceCompartmentInfo(value: 25)
//
//        let notSyncedThisDeviceCompartmentInfo =
//            NotSyncedThisDeviceCompartmentInfo(value: 0)
        
        let totalOtherDevicesCompartmentInfo =
            TotalOtherDevicesCompartmentInfo(value: barOrChartInfo.compartmentValues[0])

        let syncedThisDeviceCompartmentInfo =
            SyncedThisDeviceCompartmentInfo(value: barOrChartInfo.compartmentValues[1])

        let notSyncedThisDeviceCompartmentInfo =
            NotSyncedThisDeviceCompartmentInfo(value: barOrChartInfo.compartmentValues[2])
        
        self.compartments = [totalOtherDevicesCompartmentInfo,
                             syncedThisDeviceCompartmentInfo,
                             notSyncedThisDeviceCompartmentInfo]
        
    }
}
