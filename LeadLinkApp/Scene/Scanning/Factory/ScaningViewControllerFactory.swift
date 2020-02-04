//
//  ScaningViewControllerFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 24/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

class ScanningViewControllerFactory {
    
    var appDependancyContainer: AppDependencyContainer
    
    init(appDependancyContainer: AppDependencyContainer) {
        self.appDependancyContainer = appDependancyContainer
    }
    
    func makeVC(viewModel: ScanningViewModel) -> ScanningVC {
        
        let scanningVC = ScanningVC.instantiate(using: appDependancyContainer.sb)
        scanningVC.viewModel = viewModel
        
        scanningVC.spinnerViewManager = SpinnerViewManager(ownerViewController: scanningVC)
        
        scanningVC.disclaimerFactory = DisclaimerViewFactory()
        scanningVC.scanningProcess = ScanningProcess()
        
        return scanningVC
    }
    
}
