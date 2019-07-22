//
//  LocalComponents.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 21/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class LocalComponents {
    
    private let campaign: Campaign? = {
        let campaignId = UserDefaults.standard.value(forKey: "campaignId") as? Int ?? 0 // hard-coded
        return factory.sharedCampaignsRepository.dataStore.readCampaign(id: campaignId).value
    }()
    
    var componentsInOrder = [UIView]()
    var saveBtn: SaveButton {
        return componentsInOrder.last as! SaveButton
    }
    
    private let localComponentsViewFactory = LocalComponentsViewFactory(localComponentsSize: LocalComponentsSize())
    
    init() {
        self.componentsInOrder = [
            localComponentsViewFactory.makeTermsNoSwitchView(tag: 0, optIn: campaign?.settings.optIn),
            localComponentsViewFactory.makeTermsNoSwitchView(tag: 1, optIn: campaign?.settings.optIn),
            SaveButton()
        ]
    }
}
