//
//  StartViewControllerProvider.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 09/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class StartViewControllerProvider: StartViewControllerProviding {
    
    var factory: AppDependencyContainer

    init(factory: AppDependencyContainer) {
        self.factory = factory
    }
    func getStartViewControllers() -> [UIViewController] {
        let userSession = factory.sharedUserSessionRepository.readUserSession()
        let loginVcFactory = LoginViewControllerFactory.init(appDependancyContainer: factory)
        let loginVC = loginVcFactory.makeVC()
        let campaignsVcFactory = CampaignsViewControllerFactory.init(appDependancyContainer: factory)
        let campaignsVC = campaignsVcFactory.makeVC()
        if let _ = userSession.value {
            return [loginVC, campaignsVC]
        } else {
            return [loginVC]
        }
    }
}
