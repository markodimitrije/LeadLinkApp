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
    
    var pieChartCompartmentsOrderer: PieChartCompartmentsOrderer! // due to sort + clockwise direction
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
        setChartIntoCenter() // ne radi ?!?
        setChartInnerAndOuterRadius()
        setChartBackgroundColor()
        setGapBetweenPies()
        setReferenceAngle()
        setAnimationDuration()
    }
    
    private func setChartIntoCenter() { // ne radi ?!?
        pieChart.center = CGPoint.init(x: bounds.midX, y: bounds.midY)
    }
    
    private func setChartInnerAndOuterRadius() {
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
    
    private func setAnimationDuration() {
        pieChart.animDuration = 0.01
    }
    
    func update(compartments: [SingleCompartment]) {
        
        let compartments = pieChartCompartmentsOrderer.compartments
        
        pieChart.models = compartments.map { compartment -> PieSliceModel in
            return PieSliceModel.init(value: Double(compartment.value), color: compartment.color)
        }
        
    }
    
}
