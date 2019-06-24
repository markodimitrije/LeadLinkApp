//
//  ReportsViewControllerFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 24/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

class ReportsViewControllerFactory {
    
    var appDependancyContainer: AppDependencyContainer
    init(appDependancyContainer: AppDependencyContainer) {
        self.appDependancyContainer = appDependancyContainer
    }
    
    func makeVC(campaignId id: Int) -> ReportsVC {
        
        let reportsDataStoreFactory = DataStoreFactory.init(appDependancyContainer: appDependancyContainer)
        let reportsDataStore = reportsDataStoreFactory.makeReportsDataStore()
        
        let dataSource = ReportsDataSource.init(campaignId: id,
                                                reportsDataStore: reportsDataStore,
                                                cellId: "ReportsTVC")
        
        let delegate = ReportsDelegate()
        
        let reportsVC = ReportsVC.instantiate(using: appDependancyContainer.sb)
        
        reportsVC.dataSource = dataSource
        reportsVC.delegate = delegate
        
        return reportsVC
        
    }
    
}
