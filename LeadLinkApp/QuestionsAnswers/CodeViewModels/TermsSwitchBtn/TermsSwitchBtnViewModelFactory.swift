//
//  TermsSwitchBtnViewModelFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 11/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class TermsSwitchBtnViewModelFactory: GetViewModelProtocol {
    private let viewmodel: TermsSwitchBtnViewModel
    func getViewModel() -> QuestionPageViewModelProtocol {
        return self.viewmodel
    }
    init(questionInfo: PresentQuestionInfoProtocol) {
        self.viewmodel = TermsSwitchBtnViewModel(questionInfo: questionInfo)
    }
}
