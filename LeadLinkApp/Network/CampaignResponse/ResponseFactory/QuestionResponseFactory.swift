//
//  QuestionResponseFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 30/01/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct QuestionResponseFactory: QuestionResponseFactoryProtocol {
    func make(json: [[String: Any]]?) -> [QuestionResponseProtocol] {
        guard let jsonArr = json else {
            return [ ]
        }
        return jsonArr.compactMap { dict -> QuestionResponse? in
            return QuestionResponse(json: dict)
        }
    }
}
