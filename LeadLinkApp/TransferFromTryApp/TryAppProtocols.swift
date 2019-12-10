//
//  TryAppProtocols.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

protocol QuestionPageGetViewProtocol {
    func getView() -> UIView
}

protocol QuestionsViewItemSupplying {
    func getQuestionPageViewItems() -> [QuestionPageGetViewProtocol]
}

protocol BtnTapListening {
    func btnTapped(_ sender: UIButton)
}

protocol QuestionsViewItemManaging: QuestionsViewItemSupplying, BtnTapListening {}

protocol PresentQuestionInfoProtocol {
    func getQuestion() -> PresentQuestion
    func getAnswer() -> MyAnswer?
    func getCode() -> String
}
