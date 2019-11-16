//
//  LastDateSyncViewFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 16/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

protocol LastDateSyncViewInitializing {
    init(date: Date)
}

protocol LastDateSyncViewOutputing {
    var outputView: UIView! {get set}
}

protocol LastRefreshChartViewBuilding: LastDateSyncViewInitializing, LastDateSyncViewOutputing {}

class LastDateSyncViewFactory: LastRefreshChartViewBuilding {
    
    var outputView: UIView!
    
    required init(date: Date) {

        let frame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 200, height: 20))
        let dateView = DateView(frame: frame)
        dateView.update(descText: "Last updated at: ",
                        date: date)
        
        outputView = dateView

    }
    
}
