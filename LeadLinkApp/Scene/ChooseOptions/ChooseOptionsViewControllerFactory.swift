//
//  ChooseOptionsViewControllerFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 24/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

protocol GetViewControllerProtocol {
    func getViewController() -> UIViewController
}

protocol ChooseOptionsProtocol: GetViewControllerProtocol {
    func getChosenOptions() -> Observable<[String]>
}

class ChooseOptionsViewControllerFactory: ChooseOptionsProtocol {
    
    var appDependancyContainer: AppDependencyContainer
    
    private var myController: ChooseOptionsVC
    func getChosenOptions() -> Observable<[String]> {
        myController.chosenOptions
    }
    
    func getViewController() -> UIViewController {
        return myController
    }
    
    init(appDependancyContainer: AppDependencyContainer, questionInfo: PresentQuestionInfoProtocol) {
        
        func makeFlatChooseOptionsVC() -> ChooseOptionsVC {
            let chooseOptionsVC = ChooseOptionsVC.instantiate(using: appDependancyContainer.sb)
            let selectOptionsViewModel = SelectOptionTextFieldViewModel(question: questionInfo.getQuestion(),
                                                                        answer: questionInfo.getAnswer(),
                                                                        code: questionInfo.getCode())
            let dataSourceAndDelegate = QuestionOptionsTableViewDataSourceAndDelegate(selectOptionTextViewModel: selectOptionsViewModel)
            chooseOptionsVC.dataSourceAndDelegate = dataSourceAndDelegate
            return chooseOptionsVC
        }
        
        self.appDependancyContainer = appDependancyContainer
        self.myController = makeFlatChooseOptionsVC()
    }

}
