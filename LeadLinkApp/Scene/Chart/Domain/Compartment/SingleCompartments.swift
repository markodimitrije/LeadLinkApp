//
//  CompartmentImplementations.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 09/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

struct TotalOtherDevicesCompartmentInfo: SingleCompartmentProtocol {
    var color: UIColor
    var name: String
    var value: Int
    init(value: Int) {
        self.color = UIColor.leadLinkColor
        self.name = NSLocalizedString("Strings.Chart.Grid.TotalAllDevices.text", comment: "")
        self.value = value
    }
}

struct SyncedThisDeviceCompartmentInfo: SingleCompartmentProtocol {
    var color: UIColor
    var name: String
    var value: Int
    init(value: Int) {
        self.color = UIColor.leadLinkColor.withAlphaComponent(0.7)
        self.name = NSLocalizedString("Strings.Chart.Grid.SyncedThisDevice.text", comment: "")
        self.value = value
    }
}

struct NotSyncedThisDeviceCompartmentInfo: SingleCompartmentProtocol {
    var color: UIColor
    var name: String
    var value: Int
    init(value: Int) {
        self.color = UIColor.notSyncedWebReports
        self.name = NSLocalizedString("Strings.Chart.Grid.NotSyncedThisDevice.text", comment: "")
        self.value = value
    }
}
