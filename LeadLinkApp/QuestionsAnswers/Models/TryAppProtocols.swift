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

protocol ViewInfoProtocol {}

protocol PresentQuestionInfoProtocol: ViewInfoProtocol {
    //func getQuestion() -> PresentQuestion
    func getQuestion() -> QuestionProtocol
    func getAnswer() -> MyAnswerProtocol?
    func getCode() -> String
}

protocol GroupViewInfoProtocol: ViewInfoProtocol {
    func getTitle() -> String
}

// implementations:
// GroupViewInfo
struct GroupViewInfo {
    var title: String
    init(title: String) {
        self.title = title
    }
}
extension GroupViewInfo: GroupViewInfoProtocol {
    func getTitle() -> String {
        return self.title
    }
}

//PresentQuestionInfo
//
