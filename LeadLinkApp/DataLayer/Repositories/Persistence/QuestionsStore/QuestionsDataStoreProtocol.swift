//
//  QuestionsDataStoreProtocol.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 08/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//


import PromiseKit

protocol QuestionsDataStoreProtocol {
    
    func readAllQuestions() -> Promise<[QuestionProtocol]>
    func save(questions: [QuestionProtocol]) -> Promise<[QuestionProtocol]>
    func delete(questions: [QuestionProtocol]) -> Promise<[QuestionProtocol]>
}
