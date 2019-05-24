//
//  AppDelegate.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 30/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var factory =  AppDependencyContainer.init()
    var navigationViewModel: NavigationViewModel!
    var startVCProvider: StartViewControllerProviding!

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
            .subscribe(onNext: { index in
                if index == 0 { // logout
                    (self.window?.rootViewController as? UINavigationController)?.popToRootViewController(animated: true)
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
