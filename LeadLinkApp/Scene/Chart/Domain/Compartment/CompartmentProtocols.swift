//
//  CompartmentProtocols.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 09/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

// SingleCompartment - SingleBar

protocol SingleCompartmentColorProtocol {
    var color: UIColor {get set}
}

protocol SingleCompartmentNameProtocol {
    var name: String {get set}
}

protocol SingleCompartmentValueProtocol {
    var value: Int {get set}
}

protocol SingleCompartmentProtocol: SingleCompartmentColorProtocol, SingleCompartmentNameProtocol, SingleCompartmentValueProtocol {}
