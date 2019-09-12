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
    let sharedUserSessionRepository: UserSessionRepository
    let sharedMainViewModel: MainViewModel
    let sharedCampaignsRepository: CampaignsRepository
    let downloadImageAPI: DownloadImageAPI
    
    private let campaignsDataStore = RealmCampaignsDataStore.init()
    
    public init() {
        
        func makeUserSessionRepository() -> UserSessionRepository {
            let dataStore = makeUserSessionDataStore()
            let remoteAPI = makeAuthRemoteAPI()
            return UserSessionRepository.init(dataStore: dataStore, remoteAPI: remoteAPI)
        }

        func makeUserSessionDataStore() -> UserSessionDataStore {
            
            return FileUserSessionDataStore()

        }

        func makeAuthRemoteAPI() -> AuthRemoteAPIProtocol {
            return AuthRemoteAPI.shared
        }

        func makeMainViewModel() -> MainViewModel {
            return MainViewModel()
        }
        
        // campaignsRepository
        
        func makeCampaignsRepository() -> CampaignsRepository {
            
            //let userSession = sharedUserSessionRepository.readUserSession().value!! // oprez - ne valja ovo mislim....
            let userSessionRepository = makeUserSessionRepository()
            let dataStore = RealmCampaignsDataStore.init()
            let questionsDataStore = RealmQuestionsDataStore.init()
            let remoteAPI = CampaignsWithQuestionsRemoteAPI.shared
            let campaignsVersionChecker: CampaignsVersionChecker = {
                let dataStore = RealmCampaignsDataStore.init()
                return CampaignsVersionChecker.init(campaignsDataStore: dataStore)
            }()
            
            return CampaignsRepository.init(userSessionRepository: userSessionRepository,
                                            dataStore: dataStore, // persist campaigns + rename...
                                            questionsDataStore: questionsDataStore, // persist questions
                                            remoteAPI: remoteAPI, // ovde nadji data
                                            campaignsVersionChecker: campaignsVersionChecker)
        }
        
        self.sharedUserSessionRepository = makeUserSessionRepository()
        self.sharedMainViewModel = makeMainViewModel()
        self.sharedCampaignsRepository = makeCampaignsRepository()
        self.downloadImageAPI = DownloadImageRemoteAPI()

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
    
    private func makeUserSessionRepository() -> UserSessionRepository {
        return self.sharedUserSessionRepository
    }
    
}

// zna da li je ovaj btn visible ili ne
enum NavBarItem {
    case logout
    case stats
}
