//
//  AnswersReportsToWebPayloadFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 30/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

class AnswersReportsToWebPayloadFactory {
    func make(answer: MyAnswerProtocol) -> [String: String] {
        var res = [String: String]()
        res["question_id"] = "\(answer.questionId)"
        res["content"] = concatanateIfMultipleOptionsIn(content: answer.content)
        return res
    }
    private func concatanateIfMultipleOptionsIn(content: [String]) -> String {
        if content.count == 1 {
            return content.first!
        } else {
            return content.joined(separator: ", ")
        }
    }
}
