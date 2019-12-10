//
//  GetViewModelProtocol.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol ActualAnswerProtocol {
    func getActualAnswer() -> MyAnswer?
}

protocol QuestionPageViewModelProtocol: QuestionPageGetViewProtocol, ActualAnswerProtocol {}


protocol GetViewModelProtocol {
    func getViewModel() -> QuestionPageViewModelProtocol
}
