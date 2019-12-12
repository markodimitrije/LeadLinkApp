//
//  GroupViewItem.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class GroupViewItem: QuestionPageGetViewProtocol {

    private let viewFactory: GetViewProtocol
    private var view: UIView

    init(viewFactory: GetViewProtocol) {
        self.viewFactory = viewFactory
        let groupView = viewFactory.getView()
        self.view = groupView
    }

    func getView() -> UIView {
        return view
    }
}
