//
//  ChooseOptionsViewControllerFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 24/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

class ChooseOptionsViewControllerFactory {
    
    var appDependancyContainer: AppDependencyContainer
    
    init(appDependancyContainer: AppDependencyContainer) {
        self.appDependancyContainer = appDependancyContainer
    }
    
    func makeFlatChooseOptionsVC() -> ChooseOptionsVC {
        let chooseOptionsVC = ChooseOptionsVC.instantiate(using: appDependancyContainer.sb)
        //        let sb = UIStoryboard.init(name: "Main_iphone", bundle: nil)
        //        let chooseOptionsVC = sb.instantiateViewController(withIdentifier: "ChooseOptionsVC") as! ChooseOptionsVC
        return chooseOptionsVC
    }

}


