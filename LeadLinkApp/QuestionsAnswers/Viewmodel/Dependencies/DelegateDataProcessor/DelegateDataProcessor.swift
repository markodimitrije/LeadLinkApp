//
//  DelegateDataProcessor.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 22/02/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol DelegateDataProcessorProtocol {
    func process(delegate: Delegate?) -> Delegate?
}

struct DelegateDataProcessor {
    
    private let prepopulateDecisioner: PrepopulateDelegateDataDecisionerProtocol
    private let delegateEmailScrambler: DelegateEmailScrambling
    
    init(prepopulateDelegateDataDecisioner: PrepopulateDelegateDataDecisionerProtocol,
         delegateEmailScrambler: DelegateEmailScrambling) {
        
        self.prepopulateDecisioner = prepopulateDelegateDataDecisioner
        self.delegateEmailScrambler = delegateEmailScrambler
    }
}

extension DelegateDataProcessor: DelegateDataProcessorProtocol {

    func process(delegate: Delegate?) -> Delegate? {
        guard let delegate = delegate else {
            return nil
        }
        
        guard prepopulateDecisioner.shouldPrepopulateDelegateData() else {
            return nil
        }
        
        var myDelegate = delegate
        
        if !delegateEmailScrambler.shouldShowEmail() {
            myDelegate.email = ""
        }
        
        return myDelegate
    }
}
