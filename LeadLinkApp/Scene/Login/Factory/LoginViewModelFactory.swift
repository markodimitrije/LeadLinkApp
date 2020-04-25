//
//  LoginViewModelFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 24/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

class LoginViewModelFactory {
    
    var appDependancyContainer: AppDependencyContainer
    
    init(appDependancyContainer: AppDependencyContainer) {
        self.appDependancyContainer = appDependancyContainer
    }
    
    func makeLoginViewModel() -> LogInViewModel {
        
        let userSessionRepo = appDependancyContainer.sharedUserSessionRepository
        let mainViewModel = appDependancyContainer.sharedMainViewModel
        
        let viewmodel = LogInViewModel(userSessionRepository: userSessionRepo,
                                       signedInResponder: mainViewModel)
        return viewmodel
    }
}
