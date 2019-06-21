//
//  LocalComponents.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 21/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class LocalComponents {
    
    var componentsInOrder = [UIView]()
    var saveBtn: SaveButton {
        return componentsInOrder.last as! SaveButton
    }
    
    private let localComponentsViewFactory = LocalComponentsViewFactory(localComponentsSize: LocalComponentsSize())
    
    init() {
        self.componentsInOrder = [
            localComponentsViewFactory.makeTermsNoSwitchView(tag: 0),
            localComponentsViewFactory.makeTermsNoSwitchView(tag: 1),
            localComponentsViewFactory.makeTermsNoSwitchView(tag: 2),
            localComponentsViewFactory.makeTermsNoSwitchView(tag: 3),
            localComponentsViewFactory.makeTermsNoSwitchView(tag: 4),
            SaveButton()
        ]
    }
}
