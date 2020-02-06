//
//  CompartmentBuilder.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 11/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct CompartmentBuilder: CompartmentsProtocol {
    
    var compartments: [SingleCompartmentProtocol]
    
    init(compartmentInfo: CompartmentValuesProtocol) {

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
            TotalOtherDevicesCompartmentInfo(value: compartmentInfo.compartmentValues[0])

        let syncedThisDeviceCompartmentInfo =
            SyncedThisDeviceCompartmentInfo(value: compartmentInfo.compartmentValues[1])

        let notSyncedThisDeviceCompartmentInfo =
            NotSyncedThisDeviceCompartmentInfo(value: compartmentInfo.compartmentValues[2])
        
        self.compartments = [totalOtherDevicesCompartmentInfo,
                             syncedThisDeviceCompartmentInfo,
                             notSyncedThisDeviceCompartmentInfo]
    }
}
