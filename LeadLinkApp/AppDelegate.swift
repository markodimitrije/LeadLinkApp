//
//  AppDelegate.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 30/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ScanditBarcodeScanner

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var factory =  AppDependencyContainer.init()
    var navigationViewModel: NavigationViewModel!
    var startVCProvider: StartViewControllerProviding!
    lazy var logOutViewModel = factory.makeLogoutViewModel()
    
    let kScanditBarcodeScannerAppKey = "AUe8bIKBFoCzJJPPuiOofAM5I9owLyf0rlrGJZhQ4LInWPIVz3VonUBir7VPXdyz4h8215sLK5dVPPhCIEV6A99KUPVsfXzQfy3w9wxVlWfFRgpOaUdH+XZlMQCuAEm1Th4eu8oxKt/6x0pVplemi4IzgCa4NYURqj2bXsWKR5/PaCIcmCZIYqGj8N4DUxA853PeccM7SeMhuUnuchIjzEyCZF8BThoEEqVty7e+SVPD4jBLOBbKvn59J0Goxy3tXOqIEI+jSL5bMXSBG1AdcJrFiLE4iVTAlP9jxaTD8SxspGhbEZXdSXFFNsHfrWRZQ7usbZNQmFjcWxjGCJ9WHqMtEXxRkx5jFiDWX98ZI2cOzNAT2AgquF62Ey6cXYT0nXupoIEnCgCDPx2HeHCCjI2yAaWPwnl2PJF4iQxz8VZHzSQiaJjl0udHnL0rneb0H9lqMVHEXiemwrBIBseFsQ71bNh611ukEqDI3nIFtBEX8ZJ6jmxYqMWtBcD+0mLeE3PoUbcHyJwzjTOJx66QJdj/vIb0NsTc8e6nzsh5UrHXtbq9Wtuki6vldYx5t1JHOZOX0458xybrnfKxBzp7s3CSA3o3AD8RZfY3SWvxcrOsA7fo68bSz5FkMLnsu/FDplihfPRRJoWSDs80ySLmlau6leNkyLXK11CzOZ9O67U80vefk8BAXOVpFLK0NwSE+360G6Hq8gOhseXeCgSLAsIFvCRWcUtalnDF3t9cRK6wMeywBULSzk553ZWwjUDrvIlq7TO5SqM7hHZ9jLcijZyxzU6wOm5H9gNxfRbXgP4ZeDVTtM6sLQ=="

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        startVCProvider = StartViewControllerProvider(factory: factory)
        
        navigationViewModel = factory.makeNavigationViewModel()
        
        downloadCampaignsQuestionsAndLogos()
        
        let navVC = window?.rootViewController as? UINavigationController
        
        bindNavigationViewModelWithNavigationViewController(navViewModel: navigationViewModel,
                                                            navVC: navVC)
        
        let startingVCs = startVCProvider.getStartViewControllers()
        
        _ = startingVCs.map { vc -> Void in
            navVC?.pushViewController(vc, animated: false)
        }
        
        //navVC?.pushViewController(startingVC, animated: false)
        
        return true
    }
    
    @objc func logoutBtnTapped() {
        
        guard let topController = UIApplication.topViewController() else { fatalError() }
        let centerView = UIView.init(frame: CGRect.init(center: CGPoint.init(x: UIScreen.main.bounds.midX,
                                                                             y: UIScreen.main.bounds.midY), size: CGSize.init(width: 1, height: 1)))
        topController.view.addSubview(centerView)
            
        topController.alert(alertInfo: AlertInfo.getInfo(type: .logout), sourceView: centerView)
            .subscribe(onNext: { [weak self] index in
                if index == 0 { // logout
                    (self?.window?.rootViewController as? UINavigationController)?.popToRootViewController(animated: true)
                    self?.logOutViewModel.signOut()
                } else { // cancel
                    topController.dismiss(animated: true)
                }
            }).disposed(by: disposeBag)
    }
    
    @objc func statsBtnTapped(_ notification: NSNotification) {
        guard let info = notification.userInfo, let id = info["campaignId"] as? Int else {
            fatalError("no campaignId sent from statsBtn")
        }
        let statsVC = factory.makeStatsViewController(campaignId: id)
        (window?.rootViewController as? UINavigationController)?.pushViewController(statsVC, animated: true)
    }
    
    func downloadCampaignsQuestionsAndLogos() {
        
        let campaignsViewmodel = CampaignsViewModel.init(campaignsRepository: factory.sharedCampaignsRepository)
        
        campaignsViewmodel.getCampaignsFromWeb()
        
    }
    
    private func bindNavigationViewModelWithNavigationViewController(navViewModel: NavigationViewModel, navVC: UINavigationController?) {
        navVC?.delegate = navViewModel
        navViewModel.navBarItemsPublisher
        .subscribe(onNext: { dict in
            print("publisher has navBarDict = \(dict)")
        })
        .disposed(by: disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    
}

protocol StartViewControllerProviding {
    func getStartViewControllers() -> [UIViewController]
}

class StartViewControllerProvider: StartViewControllerProviding {
    
    var factory: AppDependencyContainer

    init(factory: AppDependencyContainer) {
        self.factory = factory
    }
    func getStartViewControllers() -> [UIViewController] {
        let userSession = factory.makeUserSessionRepository().readUserSession()
        let loginVC = factory.makeLoginViewController()
        let campaignsVC = factory.makeCampaignsViewController()
        if let _ = userSession.value {
            return [loginVC, campaignsVC]
        } else {
            return [loginVC]
        }
    }
}
