//
//  GroupSeparatorViewItem.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 22/01/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class GroupSeparatorViewItem: QuestionPageGetViewProtocol {

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
