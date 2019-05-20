//
//  AnswerModel.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 11/04/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

protocol Answering {
    var campaignId: Int {get set}
    var questionId: Int {get set}
    var code: String {get set}
    var id: String {get set}
    var content: [String] {get set}
    var optionIds: [Int]? {get set}
}

struct RadioAnswer: Answering {
    var questionId: Int // koji je ID pitanja
    var campaignId: Int
    var code = ""
    var id: String
    var content = [String]() // koji je text te opcije
    var optionIds: [Int]? // koju opciju je izabrao
    init(realmAnswer: RealmAnswer?) {
        self.questionId = realmAnswer?.questionId ?? 0
        self.campaignId = realmAnswer?.campaignId ?? 0
        self.code = realmAnswer?.code ?? ""
        
        self.id = "\(self.campaignId)" + "\(self.questionId)" + code
        
        self.content.removeAll(); self.content.append(contentsOf: Array(content))
        
        self.optionIds = [ ]
    }
    init(campaignId: Int, questionId: Int, code: String, content: [String], optionIds: [Int]) {
        self.campaignId = campaignId
        self.questionId = questionId
        self.code = code
        self.id = "\(self.campaignId)" + "\(self.questionId)" + code
        self.content = content
        self.optionIds = optionIds
    }
}

struct CheckboxAnswer: Answering {
    var campaignId: Int
    var questionId: Int // koji je ID pitanja
    var code: String
    var id: String
    var content = [String]() // koji je text te opcije
    var optionIds: [Int]? // koju opciju je izabrao - moze imati vise checkboxIds
    init(realmAnswer: RealmAnswer?) {
        self.campaignId = realmAnswer?.campaignId ?? 0
        self.questionId = realmAnswer?.questionId ?? 0
        self.code = realmAnswer?.code ?? ""
        
        self.id = "\(self.campaignId)" + "\(self.questionId)" + code
        
        let content = realmAnswer?.content ?? List<String>()
        self.content.removeAll(); self.content.append(contentsOf: Array(content))
        let noOptions = [Int]()
        var options = noOptions
        if let realmAnswer = realmAnswer {
            let optionIds = realmAnswer.optionIds ?? List<Int>()
            options = Array(optionIds)
        }
        self.optionIds = options
    }
    init(campaignId: Int, questionId: Int, code: String, optionIds: [Int], content: [String]) {
        self.campaignId = campaignId
        self.questionId = questionId
        self.code = code
        self.id = "\(self.campaignId)" + "\(self.questionId)" + code
        self.content = content
        self.optionIds = optionIds
    }
}
struct SwitchAnswer: Answering {
    var campaignId: Int
    var questionId: Int // koji je ID pitanja
    var code: String
    var id: String
    var optionIds: [Int]? // koju opciju je izabrao - moze imati vise switchIds
    var content = [String]() // koji je text te opcije
    
    init(campaignId: Int, questionId: Int, code: String, optionIds: [Int], content: [String]) {
        self.campaignId = campaignId
        self.questionId = questionId
        self.code = code
        self.id = "\(self.campaignId)" + "\(self.questionId)" + code
        self.content = content
        self.optionIds = optionIds
        print("SwitchAnswer.optionIds = \(optionIds)")
    }
    
    init(realmAnswer: RealmAnswer?) {
        self.campaignId = realmAnswer?.campaignId ?? 0
        self.questionId = realmAnswer?.questionId ?? 0
        self.code = realmAnswer?.code ?? ""
        
        self.id = "\(self.campaignId)" + "\(self.questionId)" + code
        
        let content = realmAnswer?.content ?? List<String>()
        self.content.removeAll(); self.content.append(contentsOf: Array(content))
        
        let noOptions = [Int]()
        var options = noOptions
        if let realmAnswer = realmAnswer {
            let optionIds = realmAnswer.optionIds ?? List<Int>()
            options = Array(optionIds)
        }
        print("SwitchAnswer.options.count = \(options.count)")
        self.optionIds = options

    }
}
struct OptionTextAnswer: Answering {
    var campaignId: Int
    var questionId: Int // koji je ID pitanja
    var code: String
    var id: String
    var content = [String]() // koji je od opcija izabrao (;1 ili vise njih; ako je izabrao sa searchVC)
    var optionIds: [Int]?
    
    init(campaignId: Int, questionId: Int, code: String, content: [String], optionIds: [Int]? = nil) {
        self.campaignId = campaignId
        self.questionId = questionId
        self.code = code
        self.id = "\(campaignId)" + "\(questionId)" + code
        self.content = content
        self.optionIds = optionIds
    }
    
}
struct TextAnswer: Answering {
    var campaignId: Int
    var questionId: Int // koji je ID pitanja
    var code: String
    var id: String
    var content = [String]()
    var optionIds: [Int]? = nil
    
    init(campaignId: Int, questionId: Int, code: String, content: [String], optionIds: [Int]? = nil) {
        self.campaignId = campaignId
        self.questionId = questionId
        self.code = code
        self.id = "\(campaignId)" + "\(questionId)" + code
        self.content = content
    }
    init(realmAnswer: RealmAnswer?) {
        self.campaignId = realmAnswer?.campaignId ?? 0
        self.questionId = realmAnswer?.questionId ?? 0
        self.code = realmAnswer?.code ?? ""
        
        self.id = "\(self.campaignId)" + "\(self.questionId)" + code
        
        let content = realmAnswer?.content ?? List<String>()
        self.content.removeAll(); self.content.append(contentsOf: Array(content))
        
        self.optionIds = nil
        
    }
}
