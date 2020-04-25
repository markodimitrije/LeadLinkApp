////
////  Factory.swift
////  signInApp
////
////  Created by Marko Dimitrijevic on 03/01/2019.
////  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
////

import UIKit
import RxSwift

public class AppDependencyContainer {
    
    let sb: UIStoryboard = {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIStoryboard.init(name: "Main_ipad", bundle: nil)
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            return UIStoryboard.init(name: "Main_iphone", bundle: nil)
        }
        return UIStoryboard.init(name: "Main", bundle: nil)
    }()
    
    // MARK: - Properties

    // Long-lived dependencies
    let sharedUserSessionRepository: UserSessionRepositoryProtocol
    let sharedMainViewModel: MainViewModel
    let sharedCampaignsRepository: ICampaignsRepository// mutable
    let campaignsDataStore: ICampaignsRepository // immutable
    
    public init() {

        func makeUserSessionDataStore() -> UserSessionDataStore {
            return FileUserSessionDataStore()
        }

        func makeAuthRemoteAPI() -> AuthRemoteAPIProtocol {
            return AuthRemoteAPI.shared
        }
        
        func makeUserSessionRepository() -> UserSessionRepositoryProtocol {
            let dataStore = makeUserSessionDataStore()
            let remoteAPI = makeAuthRemoteAPI()
            return UserSessionRepository.init(dataStore: dataStore, remoteAPI: remoteAPI)
        }

        func makeMainViewModel() -> MainViewModel {
            return MainViewModel()
        }
        
        self.sharedUserSessionRepository = makeUserSessionRepository()
        self.sharedMainViewModel = makeMainViewModel()
        self.sharedCampaignsRepository = RealmCampaignsDataStore()//makeCampaignsRepository()
        self.campaignsDataStore = RealmCampaignsDataStore.init()
    }
    
    func getViewControllerTypes() -> [UIViewController.Type] {
        return [LoginViewController.self,
                CampaignsVC.self,
                ScanningVC.self,
//                QuestionsAnswersVC.self,
//                ChooseOptionsVC.self
            ]
    }
    
    // MARK:- Make repositories
    
    private func makeUserSessionRepository() -> UserSessionRepositoryProtocol {
        return self.sharedUserSessionRepository
    }
    
}

// zna da li je ovaj btn visible ili ne
enum NavBarItem {
    case logout
    case stats
}
