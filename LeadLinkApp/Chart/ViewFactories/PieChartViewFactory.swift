//
//  PieChartViewFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 11/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import PieCharts

protocol PieChartViewOutputing {
    var outputView: UIView! {get set}
    func makeOutput(compartmentBuilder: BarOrChartCompartmentsInfo) -> UIView // ne treba u ouputing nego Making !
}

protocol PieChartViewBuilding: PieChartViewOutputing {}

class PieChartViewFactory: PieChartViewBuilding {
    
    var outputView: UIView!
    
    func makeOutput(compartmentBuilder: BarOrChartCompartmentsInfo) -> UIView {
        
        let compartments = compartmentBuilder.compartments
        let view = createPieChartView(compartments: compartments)
        return view
        
    }
    
    private func createPieChartView(compartments: [SingleCompartment]) -> UIView {
        let view = makePieChartView(compartments: compartments)
        return view
    }
    
    private func makePieChartView(compartments: [SingleCompartment]) -> UIView {
        
        let pieChartView = PieChart.init(frame: CGRect.init(origin: CGPoint.zero,
                                                            size: CGSize.init(width: 300, height: 500)))
        
        pieChartView.models = compartments.map { compartment -> PieSliceModel in
            return PieSliceModel.init(value: Double(compartment.value), color: compartment.color)
        }
        
        self.format(pieChartView: pieChartView)
        
        return pieChartView
        
    }
    
    private func format(pieChartView: PieChart) {
        pieChartView.backgroundColor = .yellow
    }

    
}
