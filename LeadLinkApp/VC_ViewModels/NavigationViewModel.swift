//
//  NavigationViewModel.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 14/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

// this class is observing navigationController and decides upon its knowledge, which btns to display in navBar

class NavigationViewModel: NSObject {
    
    var navBarItems: [NavBarItem]
    var viewControllerTypes: [UIViewController.Type]
    var campaignsViewModel: CampaignsViewModel
    var logOutViewModel: LogOutViewModel
    private let disposeBag = DisposeBag()
    
    var navBarItemsPublisher = PublishSubject<[NavBarItem: Bool]>() // publish this dictionary
    
    init(navBarItems: [NavBarItem],
         viewControllerTypes: [UIViewController.Type],
         campaignsViewModel: CampaignsViewModel,
         logOutViewModel: LogOutViewModel) {
        self.navBarItems = navBarItems
        self.viewControllerTypes = viewControllerTypes
        self.logOutViewModel = logOutViewModel
        self.campaignsViewModel = campaignsViewModel
        super.init()
    }
    
}

extension NavigationViewModel: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if type(of: viewController) is ChooseOptionsVC.Type {
            return
        }
        viewController.navigationItem.setRightBarButtonItems(getNavBarItems(typeName: viewController.myTypeName), animated: false)
        
    }
    
    private func getNavBarItems(typeName: String) -> [UIBarButtonItem] {
        
        let selector = #selector(NavigationViewModel.navBtnTapped(_:))
        
        let logoutItem = UIBarButtonItem.init(title: Constants.BtnTitles.logOut,
                                              style: .plain,
                                              target: self,
                                              action: selector); logoutItem.tag = 1
        let statsItem = UIBarButtonItem.init(title: Constants.BtnTitles.stats,
                                             style: .plain,
                                             target: self,
                                             action: selector); statsItem.tag = 0
        switch typeName {
        case "LoginViewController": return [ ]
        case "CampaignsVC": return [logoutItem]
        case "ScanningVC": return [logoutItem, statsItem]
        case "QuestionsAnswersVC": return []
        case "StatsVC": return [logoutItem]
        default: break
        }
        return [ ]
    }
    
    @objc func navBtnTapped(_ sender: UIBarButtonItem) {
        
        switch sender.tag {
        case 0:

            Timer.scheduledTimer(timeInterval: 0.0,
                                 target: UIApplication.shared.delegate as! AppDelegate,
                                     selector: #selector(AppDelegate.statsBtnTapped(_:)),
                                     userInfo: ["campaignId": UserDefaults.standard.value(forKey: "campaignId") as? Int],
                                     repeats: false)
        case 1:

            Timer.scheduledTimer(timeInterval: 0.0,
                                 target: UIApplication.shared.delegate as! AppDelegate,
                                 selector: #selector(AppDelegate.logoutBtnTapped),
                                 userInfo: nil,
                                 repeats: false)
        default: break
        }
    }
    
}

extension UIViewController {

    static private func getTypeName<T: UIViewController>(type: T.Type) -> String {
        return "\(type)"
    }
    
    private func getMyTypeName<T: UIViewController>(object: T) -> String {
        return "\(type(of: object))"
    }
    
    static var typeName: String {
        let s = getTypeName(type: self)
//        print("typeName = ", s)
        return s
    }
    
    var myTypeName: String {
        let s = getMyTypeName(object: self)
//        print("typeName = ", s)
        return s
    }
    
}
