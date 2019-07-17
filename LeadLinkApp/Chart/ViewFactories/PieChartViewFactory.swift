//
//  PieChartViewFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 11/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import PieCharts

// MARK:- Protocols

protocol PieChartViewOutputing {
    var outputView: UIView! {get set}
}
protocol PieChartMaking {
    func makeOutput(compartmentBuilder: BarOrChartCompartmentsInfo) -> UIView
}
protocol PieChartViewBuilding: PieChartViewOutputing, PieChartMaking {}

// MARK:- Implementation

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
        
        let frame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 300, height: 400))
        
        let pieChartView = PieChartView.init(frame: frame)
        
        pieChartView.pieChartCompartmentsOrderer = PieChartCompartmentsOrderer(compartments: compartments)
        
        pieChartView.update(compartments: compartments)
        
        return pieChartView
        
    }
    
}
