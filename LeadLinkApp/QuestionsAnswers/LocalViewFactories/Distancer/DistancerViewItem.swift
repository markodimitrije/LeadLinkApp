//
//  DistancerViewItem.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 29/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class DistancerViewItem: QuestionPageGetViewProtocol {

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
