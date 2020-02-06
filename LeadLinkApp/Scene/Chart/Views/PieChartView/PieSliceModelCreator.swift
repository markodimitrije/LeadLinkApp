//
//  Purpose: transform integer values into compartments to render in PieChart
//
//  this class receives data in it's init (var compartmentValues: [Int])
//  1. transforms those data into [SingleCompartment] (name, val, color)
//  2. transforms those data into models: [PieSliceModel]
//  models: [PieSliceModel] is property on PieChart(View) - lib PieCharts
//

import UIKit
import PieCharts

class PieSliceModelCreator {
    
    private var compartments: [SingleCompartmentProtocol]
    var models = [PieSliceModel]()
    
    init(chartData: CompartmentValuesProtocol) {
        let compartmentBuilder = CompartmentBuilder(compartmentInfo: chartData)
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
