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
//    func alert(title: String, text: String?, btnText: [String]) -> Observable<Int> {
//        return Observable.create { [weak self] observer in
//            // check if already on screen
//            guard self?.presentedViewController == nil else {
//                return Disposables.create()
//            }
//            // all good
//            //let alertVC = UIAlertController(title: title, message: text, preferredStyle: .actionSheet)
//            let alertVC = UIAlertController(title: title, message: text, preferredStyle: .alert)
//
//            _ = btnText.enumerated().map({ (index, title) -> Void in
//                alertVC.addAction(
//                    UIAlertAction(title: title, style: .default, handler: {_ in
//                        observer.onNext(index)
//                    })
//                )
//            })
//
//            self?.present(alertVC, animated: true, completion: nil)
//            return Disposables.create {
//                self?.dismiss(animated: true, completion: nil)
//            }
//        }
//    }
    //AlertInfo
    func alert(alertInfo: AlertInfo, preferredStyle: UIAlertController.Style = .actionSheet, sourceView: UIView? = nil) -> Observable<Int> {
        return Observable.create { [weak self] observer in
            // check if already on screen
            guard self?.presentedViewController == nil else {
                return Disposables.create()
            }
            
            let alertVC = UIAlertController(title: alertInfo.title, message: alertInfo.text, preferredStyle: preferredStyle)
            
            if let popoverController = alertVC.popoverPresentationController, let sourceView = sourceView {
                popoverController.sourceRect = sourceView.bounds// ?? CGRect.init(center: UIScreen.main.bounds.center, size: CGSize.zero)
                popoverController.sourceView = sourceView
                popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
            }
            
            _ = alertInfo.btnText.enumerated().map({ (index, title) -> Void in
                alertVC.addAction(
                    UIAlertAction(title: title, style: .destructive, handler: {_ in
                        observer.onNext(index)
                    })
                )
            })
            self?.present(alertVC, animated: true, completion: nil)
            
            return Disposables.create {
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}

extension Constants {
    struct AlertInfo {
        static let ok = NSLocalizedString("AlertInfo.ok", comment: "")
        struct ScanningNotSupported {
            static let title = NSLocalizedString("AlertInfo.Scan.ScanningNotSupported.title", comment: "")
            static let msg = NSLocalizedString("AlertInfo.Scan.ScanningNotSupported.msg", comment: "")
        }
        struct NoSettings {
            static let title = NSLocalizedString("AlertInfo.Scan.NoSettings.title", comment: "")
            static let msg = NSLocalizedString("AlertInfo.Scan.NoSettings.msg", comment: "")
        }
        struct Permission {
            static let title = NSLocalizedString("AlertInfo.Permission.title", comment: "")
            static let subtitle = NSLocalizedString("AlertInfo.Permission.subtitle", comment: "")
            static let cancel = NSLocalizedString("AlertInfo.Option.cancel", comment: "")
            static let agree = NSLocalizedString("AlertInfo.Option.agree", comment: "")
        }
    }
}

struct AlertInfo {
    var title: String?
    var text: String?
    var btnText: [String]
    static func getInfo(type: AlertInfoType) -> AlertInfo {
        switch type {
        case AlertInfoType.noCamera:
            return AlertInfo.init(title: Constants.AlertInfo.ScanningNotSupported.title,
                                  text: Constants.AlertInfo.ScanningNotSupported.msg,
                                  btnText: [Constants.AlertInfo.ok])
        case AlertInfoType.dataPermission:
            return AlertInfo.init(title: Constants.AlertInfo.Permission.title,
                                  text: Constants.AlertInfo.Permission.subtitle,
                                  btnText: [Constants.AlertInfo.Permission.agree, Constants.AlertInfo.Permission.cancel])
        }
    }
}

enum AlertInfoType {
    case noCamera
    case dataPermission
}



