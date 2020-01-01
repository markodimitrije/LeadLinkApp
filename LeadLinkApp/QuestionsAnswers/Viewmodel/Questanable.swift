//
//  Questanable.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 01/01/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol Questanable {
    var question: QuestionProtocol {get set}
    var code: String {get set}
}
