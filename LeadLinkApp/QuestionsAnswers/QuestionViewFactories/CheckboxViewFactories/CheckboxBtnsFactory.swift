//
//  CheckboxBtnsFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class CheckboxBtnsFactory: GetViewProtocol {
   
    private var myView: UIView!
    private var singleCheckboxBtnViewModels: [SingleCheckboxBtnViewModel]!
    
    func getView() -> UIView {
        return myView
    }
    
    func getViewModels() -> [SingleCheckboxBtnViewModel] {
        return self.singleCheckboxBtnViewModels
    }
    
    init(question: PresentQuestion, answer: MyAnswerProtocol?) {
        
        let titles = question.options
        
        let selected = titles.map {(answer?.content ?? [ ]).contains($0)}
        
        let singleCheckboxBtnViewModels = titles.enumerated().map {
            (index, title) -> SingleCheckboxBtnViewModel in
                let checkboxBtnFactory = SingleCheckboxBtnViewFactory(tag: index,
                                                                      isOn: selected[index],
                                                                      titleText: title)
            let checkboxBtnViewModel = SingleCheckboxBtnViewModel(viewFactory: checkboxBtnFactory, isOn: selected[index])
            return checkboxBtnViewModel
        }
        self.singleCheckboxBtnViewModels = singleCheckboxBtnViewModels
        let singleViews = singleCheckboxBtnViewModels.map {$0.getView()}
        let verticalStackerFactory = CodeVerticalStacker(views: singleViews)
        
        self.myView = verticalStackerFactory.getView()
        
    }
    
}


