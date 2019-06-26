//
//  TermsViewControllerFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 24/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class TermsViewControllerFactory {
    
    var appDependancyContainer: AppDependencyContainer
    
    init(appDependancyContainer: AppDependencyContainer) {
        self.appDependancyContainer = appDependancyContainer
    }
    
    func makeVC(termsTxt: String? = nil) -> UINavigationController {
    
        guard let navForTerms = NavForTermsVC.instantiate(using: appDependancyContainer.sb) as? NavForTermsVC,
            let termsVC = navForTerms.viewControllers.first as? TermsVC else { fatalError() }
    
        termsVC.termsTxt.accept(termsString)//text)
        
        return navForTerms
        
    }
}
