//
//  CompartmentImplementations.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 09/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

//struct SingleCompartmentInfo: SingleCompartment {
//    var color: UIColor
//    var name: String
//    var value: Int
//    init(color: UIColor, name: String, value: Int) {
//        self.color = color
//        self.name = name
//        self.value = value
//    }
//}

struct TotalOtherDevicesCompartmentInfo: SingleCompartment {
    var color: UIColor
    var name: String
    var value: Int
    init(value: Int) {
        self.color = UIColor.blue
        self.name = "total (other devices)"
        self.value = value
    }
}

struct SyncedThisDeviceCompartmentInfo: SingleCompartment {
    var color: UIColor
    var name: String
    var value: Int
    init(value: Int) {
        self.color = UIColor.green
        self.name = "synced (this device)"
        self.value = value
    }
}

struct NotSyncedThisDeviceCompartmentInfo: SingleCompartment {
    var color: UIColor
    var name: String
    var value: Int
    init(value: Int) {
        self.color = UIColor.red
        self.name = "not synced (this device)"
        self.value = value
    }
}
