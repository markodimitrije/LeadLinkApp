//
//  PieSliceModelCreator.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import PieCharts

class PieSliceModelCreator {
    
    private var compartments: [SingleCompartment]
    var models = [PieSliceModel]()
    
    init(chartData: BarOrChartData) {
        let compartmentBuilder = CompartmentBuilder(barOrChartInfo: chartData)
        let pieChartCompartmentsOrderer = PieChartCompartmentsOrderer(compartments: compartmentBuilder.compartments)
        self.compartments = pieChartCompartmentsOrderer.compartments
        
        self.makePieSliceModels()
    }
    private func makePieSliceModels() {
        
        var tweakCompartments = self.compartments
        
        let total = tweakCompartments.first(where: {$0 is TotalOtherDevicesCompartmentInfo})!.value
        let synced = tweakCompartments.first(where: {$0 is SyncedThisDeviceCompartmentInfo})!.value
        let notSynced = tweakCompartments.first(where: {$0 is NotSyncedThisDeviceCompartmentInfo})!.value
        
        let modifiedTotal = total - (synced + notSynced)
        
        if let index = tweakCompartments.lastIndex(where: {$0 is TotalOtherDevicesCompartmentInfo}) {
            tweakCompartments[index].value = modifiedTotal
        }
        
        self.models = tweakCompartments.map { compartment -> PieSliceModel in
            return PieSliceModel.init(value: Double(compartment.value), color: compartment.color)
        }
        
    }
}
