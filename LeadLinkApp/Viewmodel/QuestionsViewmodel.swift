//
//  QuestionsViewmodel.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 19/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

class QuestionsViewmodel {
    
    var scanningViewmodel: ScanningViewModel
    
    init(scanningViewmodel: ScanningViewModel) {
        self.scanningViewmodel = scanningViewmodel
    }
    
    private let disposeBag = DisposeBag()
    
    
    
}
