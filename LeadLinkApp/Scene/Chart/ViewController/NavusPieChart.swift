//
//  NavusPieChart.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 05/02/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import PieCharts

class NavusPieChart: PieChart {
    private var rect = CGRect.zero
    override init(frame: CGRect) {
        self.rect = frame
        super.init(frame: frame)
        format()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    private func format() {
        formatRadius()
        formatColor()
        setGapBetweenPies()
        setReferenceAngle()
    }
    
    private func formatRadius() {
        self.innerRadius = rect.width / 5
        self.outerRadius = rect.width / 2.5
    }
    
    private func formatColor() {
        self.tintColor = .white
        self.backgroundColor = .white
    }
    
    private func setGapBetweenPies() {
        self.strokeWidth = 10.0
        self.strokeColor = .white
    }
    
    private func setReferenceAngle() {
        self.referenceAngle = 270.0
    }
}
