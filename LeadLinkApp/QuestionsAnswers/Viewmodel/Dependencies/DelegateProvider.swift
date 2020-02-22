//
//  DelegateProvider.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 22/02/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift

protocol DelegateProviderProtocol {
    var obsDelegate: Observable<Delegate?> { get }
}

class DelegateProvider: DelegateProviderProtocol {
    
    var obsDelegate: Observable<Delegate?>
    
    private let bag: DisposeBag
    private let dataProcessor: DelegateDataProcessorProtocol
    
    init(obsDelegate: Observable<Delegate?>, delegateDataProcessor: DelegateDataProcessorProtocol, bag: DisposeBag) {
        self.obsDelegate = obsDelegate
        self.dataProcessor = delegateDataProcessor
        self.bag = bag
        processObsDelegate()
    }
    
    private func processObsDelegate() {
        self.obsDelegate = self.obsDelegate.map(dataProcessor.process)
    }

}
