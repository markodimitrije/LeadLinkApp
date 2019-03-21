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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        navigationViewModel = factory.makeNavigationViewModel()
        
        downloadCampaignsQuestionsAndLogos()
        
        bindNavigationViewModelWithNavigationViewController(navViewModel: navigationViewModel,
                                                            navVC: window?.rootViewController as? UINavigationController)
        
        return true
    }
    
    @objc func logoutBtnTapped() {
        (window?.rootViewController as? UINavigationController)?.popToRootViewController(animated: true)
    }
    
    @objc func statsBtnTapped() {
        //let statsVC = factory.makeStatsViewController()
        let statsVC = factory.makeStatsViewController(campaignId: 9) // hard-coded
        (window?.rootViewController as? UINavigationController)?.pushViewController(statsVC, animated: true)
    }
    
    func downloadCampaignsQuestionsAndLogos() {
        
        //print("AppDelegate.downloadCampaignsQuestionsAndLogos/ zovi svoj viewmodel da ti da podatke")
        
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
