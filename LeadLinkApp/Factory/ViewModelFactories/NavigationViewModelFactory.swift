//
//  NavigationViewModelFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 24/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

class NavigationViewModelFactory {
    
    var appDependancyContainer: AppDependencyContainer
    
    init(appDependancyContainer: AppDependencyContainer) {
        self.appDependancyContainer = appDependancyContainer
    }
    
    func makeViewModel() -> NavigationViewModel {
        
        let items = [NavBarItem.stats, NavBarItem.logout]

        let logoutViewModelFactory = LogoutViewModelFactory(appDependancyContainer: appDependancyContainer)
        let logoutViewModel = logoutViewModelFactory.makeViewModel()

        let campaignsViewModelFactory = CampaignsViewModelFactory(appDependancyContainer: appDependancyContainer)
        let campaignsViewModel = campaignsViewModelFactory.makeViewModel()
        
        let viewControllerTypes = appDependancyContainer.getViewControllerTypes()

        let viewmodel = NavigationViewModel.init(navBarItems: items,
                                                 viewControllerTypes: viewControllerTypes,
                                                 campaignsViewModel: campaignsViewModel,
                                                 logOutViewModel: logoutViewModel)
        return viewmodel
    }
}

