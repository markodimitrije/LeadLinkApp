//
//  ChartViewControllerFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 24/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class ChartViewControllerFactory {
    
    var appDependancyContainer: AppDependencyContainer
    init(appDependancyContainer: AppDependencyContainer) {
        self.appDependancyContainer = appDependancyContainer
    }
    
    func makeVC(campaignId id: Int) -> UIViewController {
        
        //        let codesVC = sb.instantiateViewController(withIdentifier: "CodesVC") as! CodesVC
        //
        //        codesVC.codesDataSource = CodesDataSource.init(campaignId: id,
        //                                                       codesDataStore: makeCodeDataStore(),
        //                                                       cellId: "CodesCell")
        //        codesVC.codesDelegate = CodesDelegate()
        
        //        return codesVC
        return UIViewController.init()
        
    }
}
