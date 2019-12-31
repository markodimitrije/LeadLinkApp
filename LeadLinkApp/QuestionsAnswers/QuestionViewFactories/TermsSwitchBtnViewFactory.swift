//
//  TermsSwitchBtnViewFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 11/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class TermsSwitchBtnViewFactory: GetViewProtocol {
    private let myView: UIView
    func getView() -> UIView {
        return self.myView
    }

    init(surveyQuestion: SurveyQuestionProtocol, isOn: Bool) {
        let options = surveyQuestion.getQuestion().qOptions
        let titleWithHiperlinkViewFactory =
            TextWithHiperlinkViewFactory(text: options.first!,
                                          hiperlinkText: options.last!,
                                          urlString: Constants.PrivacyPolicy.navusUrl)
        
        let switchBtn = UISwitch()
        switchBtn.isOn = isOn
        
        let textsView = titleWithHiperlinkViewFactory.getView()
        let textViewWidth = allowedQuestionsWidth - 8.0 - switchBtn.bounds.width
        textsView.widthAnchor.constraint(equalToConstant: textViewWidth).isActive = true
        textsView.layer.borderWidth = 0.0
        
        let stackView = CodeHorizontalStacker(views: [textsView, switchBtn], distribution: .fill).getView()
        
        self.myView = stackView
        switchBtn.trailingAnchor.constraint(equalTo: self.myView.trailingAnchor, constant: 0).isActive = true
        
    }
}
