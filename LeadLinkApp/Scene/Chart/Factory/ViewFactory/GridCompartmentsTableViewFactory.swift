//
//  CompartmentsInGridViewFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 09/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class CompartmentsInGridViewFactory {
    
    private var compartments = [SingleCompartmentProtocol]()
    private var compartmentViews = [SingleRowGridTableView]()
    
    var outputView = UIStackView(arrangedSubviews: [])
    
    init(compartmentBuilder: BarOrChartCompartmentsProtocol) {
        self.compartments = compartmentBuilder.compartments
        self.createOutput()
    }
    
    private func createOutput() {
        
        loadCompartmentViews()
        insertCompartmentsIntoGridTableView()
        formatGridView()
    
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
