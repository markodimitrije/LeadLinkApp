//
//  SaveBtnViewItem.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 11/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class SaveBtnViewItem: QuestionPageGetViewProtocol {
    
    private var view: UIView
    
    init(saveBtnFactory: SaveButtonFactory) {
        self.view = saveBtnFactory.getView()
    }
    
    func getView() -> UIView {
        return self.view
    }
}
