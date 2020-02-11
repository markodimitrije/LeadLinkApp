//
//  SpinnerViewManager.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 25/09/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class SpinnerViewManager: SpinnerViewManaging {
    var ownerViewController: UIViewController
    let child = SpinnerViewController()
    init(ownerViewController: UIViewController) {
        self.ownerViewController = ownerViewController
    }
    func showSpinnerView() {
        ownerViewController.addChild(child)
        child.view.frame = ownerViewController.view.frame
        ownerViewController.view.addSubview(child.view)
        child.didMove(toParent: ownerViewController)
    }
    func removeSpinnerView() {
        DispatchQueue.main.async() {
            self.child.willMove(toParent: nil)
            self.child.view.removeFromSuperview()
            self.child.removeFromParent()
        }
    }
}
