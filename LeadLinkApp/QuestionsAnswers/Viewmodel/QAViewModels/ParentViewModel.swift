//
//  ParentViewModel.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 25/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift

class ParentViewModel: QuestionsViewItemManaging {
    
    func getQuestionPageViewItems() -> [QuestionPageGetViewProtocol] {
        return items
    }
    
    func btnTapped(_ sender: UIButton) {
        print("implement me, save btn tapped....")
    }
    
    private var questionInfos = [PresentQuestionInfoProtocol]()
    private var items = [QuestionPageGetViewProtocol]()
    var childViewmodels = [Int: Questanable]()
    
    init(questionInfos: [PresentQuestionInfoProtocol]) {
        self.questionInfos = questionInfos
        _ = questionInfos.map { info in
            if info.getQuestion().type == .textField {
                let dropdownItem = DropdownViewModelFactory(questionInfo: info).getViewModel()
                items.append(dropdownItem)
            }
        }
    }
    
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

class QuestionInfoFactory {
    func convert(surveyQuestion: SurveyQuestion) -> PresentQuestionInfoProtocol {
        let question = surveyQuestion.question
        let answer = surveyQuestion.answer
        let code = "3" // hard-coded
        return PresentQuestionInfo(question: question, answer: answer, code: code)
    }
}
