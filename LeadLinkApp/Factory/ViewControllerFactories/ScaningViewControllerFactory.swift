//
//  ScaningViewControllerFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 24/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

class ScaningViewControllerFactory {
    
    var appDependancyContainer: AppDependencyContainer
    
    init(appDependancyContainer: AppDependencyContainer) {
        self.appDependancyContainer = appDependancyContainer
    }
    
    func makeVC(viewModel: ScanningViewModel?) -> ScanningVC {
        
        let scanningVC = ScanningVC.instantiate(using: appDependancyContainer.sb)
        if let viewModel = viewModel {
            scanningVC.viewModel = viewModel
        }
        return scanningVC
    }
}
