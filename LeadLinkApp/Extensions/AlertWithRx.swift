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

struct AlertInfo {
    var title: String?
    var text: String?
    var btnText: [String]
    static func getInfo(type: AlertInfoType) -> AlertInfo {
        switch type {
        case .noCamera:
            return AlertInfo.init(title: Constants.AlertInfo.ScanningNotSupported.title,
                                  text: Constants.AlertInfo.ScanningNotSupported.msg,
                                  btnText: [Constants.AlertInfo.ok])
        case .dataPermission:
            return AlertInfo.init(title: Constants.AlertInfo.Permission.title,
                                  text: Constants.AlertInfo.Permission.subtitle,
                                  btnText: [Constants.AlertInfo.Permission.agree, Constants.AlertInfo.Permission.cancel])
        case .noCodeDetected:
            return AlertInfo.init(title: Constants.AlertInfo.NoCodeDetected.title,
                                  text: Constants.AlertInfo.NoCodeDetected.msg,
                                  btnText: [Constants.AlertInfo.ok])
        case .logout:
            return AlertInfo.init(title: Constants.AlertInfo.logout.title,
                                  text: "",
                                  btnText: [Constants.AlertInfo.ok,
                                            Constants.AlertInfo.cancel])
        case .questionsFormNotValid:
            return AlertInfo.init(title: Constants.AlertInfo.questionsFormNotValid.title,
                                  text: Constants.AlertInfo.questionsFormNotValid.msg,
                                  btnText: [Constants.AlertInfo.ok])
     
        case .readingCampaignsError:
            return AlertInfo.init(title: Constants.AlertInfo.readingCampaignsError.title,
                              text: Constants.AlertInfo.readingCampaignsError.msg,
                              btnText: [Constants.AlertInfo.ok])
        
        case .noCampaigns:
            return AlertInfo.init(title: Constants.AlertInfo.noCampaignsError.title,
                                  text: Constants.AlertInfo.noCampaignsError.msg,
                                  btnText: [Constants.AlertInfo.ok])
    
        }
    }
}

enum AlertInfoType {
    case noCamera
    case dataPermission
    case noCodeDetected
    case logout
    case questionsFormNotValid
    case readingCampaignsError
    case noCampaigns
}



