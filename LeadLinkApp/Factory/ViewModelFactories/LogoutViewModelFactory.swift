//
//  LogoutViewModelFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 24/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

class LogoutViewModelFactory {
    
    var appDependancyContainer: AppDependencyContainer
    
    init(appDependancyContainer: AppDependencyContainer) {
        self.appDependancyContainer = appDependancyContainer
    }
    
    func makeViewModel() -> LogOutViewModel {
        
        let userSessionRepo = appDependancyContainer.sharedUserSessionRepository
        let mainViewModel = appDependancyContainer.sharedMainViewModel
        
        let viewmodel = LogOutViewModel.init(userSessionRepository: userSessionRepo,
                                             notSignedInResponder: mainViewModel)
        return viewmodel
    }
}
