//
//  File.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 08/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//


import PromiseKit

public protocol QuestionsDataStore {
    
    func readAllQuestions() -> Promise<[Question]>
    func save(questions: [Question]) -> Promise<[Question]>
    func delete(questions: [Question]) -> Promise<[Question]>
    
}
