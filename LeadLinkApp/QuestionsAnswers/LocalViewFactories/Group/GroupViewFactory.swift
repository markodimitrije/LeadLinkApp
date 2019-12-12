//
//  GroupViewFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class GroupViewFactory: GetViewProtocol {
    private let myView: UIView
    func getView() -> UIView {
        return myView
    }
    init(text: String) {
        self.myView = LabelFactory(text: text).getView()
        let label = self.myView.findViews(subclassOf: UILabel.self).first!
        label.backgroundColor = .darkGray
    }
}
