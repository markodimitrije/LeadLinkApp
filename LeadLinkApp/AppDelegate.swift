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

let kScanditBarcodeScannerAppKey = "ASHdMpiBDE75BbkR4xSxe94Ezm55L9o9KH8QCJpnArp5YMw09nsx3WBp35/nLtAQzmSC0CJNnYphbuRJWnevrfoxs6hqIw0HNQBnWE5oezqEQ09DYlBPKwkgQgn+Ep4DiwLrV8oXC53SOeo9IuLiG1TWKlVVkgPeLkIdj36yzjk++ZXCyU2NpMieDq1bqtjufDwK1OxtorxerOyeE4ow4xI1h35YvQ7MlUaVrJPgjzqOXfFxbzokcCfPECvTequ5bblhOyAKn6bZrB0GLoAriPGJMXV0gauof1vMu7HSyLYvdqUfu+x7guuB6aO3Wv2nbYypK+EjuqHYfujLpKR+FNK6870HBdqYCetDVi88a4wEeO6oskUr+kudb6rgN/miXylATAWKWzZ7DlHmAAF6m4YSMjgRQYtWYoDblGqdOkmZlJwe3SwTKqhYan6F0Wvm3wafNcrQmFEjkFp2jD5aMC2Pz+LLicSXu+xavUega5BOXMLCpC9RBXx7Hxn3sD11IYUG3CCjD5Zcix10YDAzS8tscEdYru9CM6CdJNRMIKteR+nSOSRSPBG8fje0Tm+XT048+OPyZf6USMD1J+AzmBp6sixOS6u/n4+3gSL3FFhs3J6rRSoDBy5OMwSH6A5HT27vwSR5s4YX9yAl4dJde1RR5IxEIeAterd4PIpWJIJNMgQo65P3JYC1oVMtAImV25cE39JXeZvl+tY9bw4q9TLMMqZxjbg/4v4Ic4MwsQysFTjHN05NVw/gGhe4pOiif7/pJGOch4uNKUEWc0TcYUPXjcDaV2mv8oZXu65ciejO2txH"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationViewModel: NavigationViewModel!
    var startVCProvider: StartViewControllerProviding!
    lazy var logOutViewModel = factory.makeLogoutViewModel()
    
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
        
        SBSLicense.setAppKey(kScanditBarcodeScannerAppKey)
        
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
        let statsVcFactory = StatsViewControllerFactory.init(appDependancyContainer: factory)
        let statsVC = statsVcFactory.makeVC(campaignId: id)
        
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
        let loginVcFactory = LoginViewControllerFactory.init(appDependancyContainer: factory)
        let loginVC = loginVcFactory.makeVC()
        let campaignsVcFactory = CampaignsViewControllerFactory.init(appDependancyContainer: factory)
        let campaignsVC = campaignsVcFactory.makeVC()
        if let _ = userSession.value {
            return [loginVC, campaignsVC]
        } else {
            return [loginVC]
        }
    }
}
