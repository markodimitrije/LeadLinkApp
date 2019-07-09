//
//  ChartViewFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 09/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class ChartViewFactory {
    
    private var barOrChartInfo: BarOrChartInfo
    private var compartments = [SingleCompartment]()
    private var compartmentViews = [SingleRowGridTableView]()
    
    var gridView = UIStackView(arrangedSubviews: [])
    
    init(barOrChartInfo: BarOrChartInfo) {
        self.barOrChartInfo = barOrChartInfo
        self.loadGridView()
    }
    
    private func loadGridView() {
        
        loadCompartments()
        loadCompartmentViews()
        insertCompartmentsIntoGridTableView()
        
        formatGridView()
    
    }
    
    private func loadCompartments() {
        
        let totalOtherDevicesCompartmentInfo = TotalOtherDevicesCompartmentInfo(value:barOrChartInfo.otherDevicesSyncedCount)
        
        let syncedThisDeviceCompartmentInfo = SyncedThisDeviceCompartmentInfo(value: barOrChartInfo.thisDeviceSyncedCount)
        
        let notSyncedThisDeviceCompartmentInfo = NotSyncedThisDeviceCompartmentInfo(value:barOrChartInfo.thisDeviceNotSyncedCount)
        
        self.compartments =  [totalOtherDevicesCompartmentInfo,
                              syncedThisDeviceCompartmentInfo,
                              notSyncedThisDeviceCompartmentInfo]
    }
    
    private func loadCompartmentViews() {
    
        self.compartmentViews = compartments.map {
            compartmentInfo -> SingleRowGridTableView in
            let view = SingleRowGridTableView()
            view.update(singleCompartmentInfo: compartmentInfo)
            return view
        }
    
    }
    
    private func insertCompartmentsIntoGridTableView() {
        
        _ = compartmentViews.map { view in
            gridView.addArrangedSubview(view)
        }
        
    }
    
    private func formatGridView() {
        gridView.axis = .vertical // format...
        gridView.distribution = UIStackView.Distribution.fillEqually
    }
    
}

struct SingleCompartmentInfo: SingleCompartment {
    var color: UIColor
    var name: String
    var value: Int
    init(color: UIColor, name: String, value: Int) {
        self.color = color
        self.name = name
        self.value = value
    }
}

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
