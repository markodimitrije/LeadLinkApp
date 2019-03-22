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
    //var codesDataStore: CodesDataStore
    
    var saveBtnEvent: Observable<Void>!
    
    //init(scanningViewmodel: ScanningViewModel, codesDataStore: CodesDataStore) {
    init(scanningViewmodel: ScanningViewModel) {
        self.scanningViewmodel = scanningViewmodel
        //self.codesDataStore = codesDataStore
    }
    
    private let disposeBag = DisposeBag()
    
}
