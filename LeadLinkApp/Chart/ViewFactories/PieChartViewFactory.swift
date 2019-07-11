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
    func makeOutput(webReports: [RealmWebReportedAnswers], campaign: Campaign) -> UIView
}

protocol PieChartViewBuilding: PieChartViewOutputing {}

class PieChartViewFactory: PieChartViewBuilding {
    
    var outputView: UIView!
    
    func makeOutput(webReports: [RealmWebReportedAnswers], campaign: Campaign) -> UIView {
        
        let view = createPieChartView(webReports: webReports, campaign: campaign)
        
        return view
        
    }
    
    private func createPieChartView(webReports: [RealmWebReportedAnswers], campaign: Campaign) -> UIView {
        let barOrChartData = BarOrChartData(campaign: campaign, webReports: webReports)
        let view = makePieChartView(barOrChartData: barOrChartData)
        return view
    }
    
    private func makePieChartView(barOrChartData: BarOrChartData) -> UIView {
        
        let pieChartView = PieChart.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 300, height: 500)))
        
        pieChartView.models = barOrChartData.compartmentValues.map { value -> PieSliceModel in
            return PieSliceModel.init(value: Double(value), color: .red)
        }
        
        self.format(pieChartView: pieChartView)
        
        return pieChartView
        
    }
    
    private func format(pieChartView: PieChart) {
        pieChartView.backgroundColor = .yellow
    }

    
}
