//
//  PieChartView.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import PieCharts

class PieChartView: UIView {
    
    @IBOutlet var pieChart: PieChart!
    
    var pieChartCompartmentsOrderer: PieChartCompartmentsOrderer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PieChartView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        formatPieChart()
        
        self.addSubview(view)
        
    }
    
    private func formatPieChart() {
        setChartIntoCenter()
        setRadiuses()
        setChartBackgroundColor()
        setGapBetweenPies()
        setReferenceAngle()
    }
    
    private func setChartIntoCenter() { // ne radi ?!?
        pieChart.center = CGPoint.init(x: bounds.midX, y: bounds.midY)
    }
    
    private func setRadiuses() {
        pieChart.innerRadius = 0.25 * bounds.width
        pieChart.outerRadius = 0.50 * bounds.width
    }
    
    private func setChartBackgroundColor() {
        pieChart.backgroundColor = .white
    }
    
    private func setGapBetweenPies() {
        pieChart.strokeWidth = 10.0
        pieChart.strokeColor = .white
    }
    
    private func setReferenceAngle() {
        pieChart.referenceAngle = 270.0
    }
    
    func update(compartments: [SingleCompartment]) {
        
        let compartments = pieChartCompartmentsOrderer.compartments
        
        pieChart.models = compartments.map { compartment -> PieSliceModel in
            return PieSliceModel.init(value: Double(compartment.value), color: compartment.color)
        }
        
    }
    
}

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
