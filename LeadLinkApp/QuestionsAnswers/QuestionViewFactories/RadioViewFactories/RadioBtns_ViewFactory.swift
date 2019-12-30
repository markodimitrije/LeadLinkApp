//
//  RadioBtns_ViewFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 11/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class RadioBtns_ViewFactory: GetViewProtocol {
   
    private var myView: UIView!
    private var singleRadioBtnViewModels: [SingleRadioBtnViewModel]!
    
    func getView() -> UIView {
        return myView
    }
    
    func getViewModels() -> [SingleRadioBtnViewModel] {
        return self.singleRadioBtnViewModels
    }
    
    init(question: PresentQuestion, answer: MyAnswerProtocol?) {
        
        let titles = question.options
        
        let selected = titles.map {(answer?.content ?? [ ]).contains($0)}
        
        let singleRadioBtnViewModels = titles.enumerated().map { (index, title) -> SingleRadioBtnViewModel in

            let radioBtnFactory = SingleRadioBtnViewFactory(tag: index,
                                                            isOn: selected[index],
                                                            titleText: title)
            let radioBtnViewModel = SingleRadioBtnViewModel(viewFactory: radioBtnFactory, isOn: selected[index])
            return radioBtnViewModel
        }
        self.singleRadioBtnViewModels = singleRadioBtnViewModels
        let singleRadioViews = singleRadioBtnViewModels.map {$0.getView()}
        
        let labelView = LabelFactory(text: question.headlineText, width: allowedQuestionsWidth).getView()
        
        let allViews = [labelView] + singleRadioViews
        let verticalStackerFactory = CodeVerticalStacker(views: allViews)
        
        self.myView = verticalStackerFactory.getView()
        
    }
    
}

