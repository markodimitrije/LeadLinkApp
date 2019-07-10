//
//  CompartmentsInGridViewFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 09/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class CompartmentsInGridViewFactory {
    
    private var barOrChartInfo: BarOrChartInfo
    private var compartments = [SingleCompartment]()
    private var compartmentViews = [SingleRowGridTableView]()
    
    var outputView = UIStackView(arrangedSubviews: [])
    
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
        
        let totalOtherDevicesCompartmentInfo =
            TotalOtherDevicesCompartmentInfo(value: barOrChartInfo.compartmentValues[0])
        
        let syncedThisDeviceCompartmentInfo =
            SyncedThisDeviceCompartmentInfo(value: barOrChartInfo.compartmentValues[1])
        
        let notSyncedThisDeviceCompartmentInfo = NotSyncedThisDeviceCompartmentInfo(value:barOrChartInfo.compartmentValues[2])
        
        self.compartments = [totalOtherDevicesCompartmentInfo,
                             syncedThisDeviceCompartmentInfo,
                             notSyncedThisDeviceCompartmentInfo]
    }
    
    private func loadCompartmentViews() {
    
        self.compartmentViews = compartments.map {
            singleCompartment -> SingleRowGridTableView in
            let view = SingleRowGridTableView()
            view.update(compartment: singleCompartment)
            return view
        }
    
    }
    
    private func insertCompartmentsIntoGridTableView() {
        
        _ = compartmentViews.map { view in
            outputView.addArrangedSubview(view)
        }
        
    }
    
    private func formatGridView() {
        outputView.axis = .vertical // format...
        outputView.distribution = UIStackView.Distribution.fillEqually
    }
    
}
