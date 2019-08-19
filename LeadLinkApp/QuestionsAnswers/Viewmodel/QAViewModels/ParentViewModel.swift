//
//  ParentViewModel.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 25/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift

class ParentViewModel {

    var childViewmodels = [Int: Questanable]()
    
    init(viewmodels: [Questanable]) {
        
        _ = viewmodels.map { viewmodel -> Void in
            
            childViewmodels[viewmodel.question.id] = viewmodel
        }
    }
}

protocol Questanable {
    var question: PresentQuestion {get set}
    var code: String {get set}
}

protocol Answerable {
    var answer: MyAnswer? {get set}
}
