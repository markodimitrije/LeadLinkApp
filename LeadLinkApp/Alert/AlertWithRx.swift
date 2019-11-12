//
//  AlertWithRx.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 01/11/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import RxSwift
import RxSwift.Swift
import SwiftOnoneSupport
import RxCocoa
import UIKit

extension UIViewController {

    //AlertInfo
    func alert(alertInfo: AlertInfo, preferredStyle: UIAlertController.Style = .actionSheet, sourceView: UIView? = nil) -> Observable<Int> {
        return Observable.create { [weak self] observer in
            // check if already on screen
            guard self?.presentedViewController == nil else {
                return Disposables.create()
            }
            
            let alertVC = UIAlertController(title: alertInfo.title, message: alertInfo.text, preferredStyle: preferredStyle)
            
            if let popoverController = alertVC.popoverPresentationController {
                if let sourceView = sourceView {
                    popoverController.sourceRect = sourceView.bounds
                    popoverController.sourceView = sourceView
                } else {
                    popoverController.barButtonItem = UIApplication.topViewController()!.navigationItem.rightBarButtonItems?.first
                }
                popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
            }
            
            _ = alertInfo.btnText.enumerated().map { (index, title) -> Void in
                alertVC.addAction(
                    UIAlertAction(title: title, style: .destructive, handler: {_ in
                        observer.onNext(index)
                    })
                )
            }
            self?.present(alertVC, animated: true, completion: nil)
            
            return Disposables.create()
        }
    }
    
}



