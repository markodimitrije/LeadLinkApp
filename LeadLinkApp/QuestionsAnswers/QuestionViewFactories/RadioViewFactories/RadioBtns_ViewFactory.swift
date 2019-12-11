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
    
    init(question: PresentQuestion, answer: MyAnswer?) {
        
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
        let singleViews = singleRadioBtnViewModels.map {$0.getView()}
        let verticalStackerFactory = CodeVerticalStacker(views: singleViews)
        
        self.myView = verticalStackerFactory.getView()
        
    }
    
}

