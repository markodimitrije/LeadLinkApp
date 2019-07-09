//
//  CompartmentProtocols.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 09/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

// SingleCompartment - SingleBar

protocol SingleCompartmentColor {
    var color: UIColor {get set}
}

protocol SingleCompartmentName {
    var name: String {get set}
}

protocol SingleCompartmentValue {
    var value: Int {get set}
}

protocol SingleCompartment: SingleCompartmentColor, SingleCompartmentName, SingleCompartmentValue {}
