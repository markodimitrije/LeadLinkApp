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
        self.innerRadius = rect.width / 5
        self.outerRadius = rect.width / 2.5
        self.tintColor = .white
        self.backgroundColor = .yellow
    }
}
