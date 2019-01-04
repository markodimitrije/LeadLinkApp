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

    let sb = UIStoryboard.init(name: "Main", bundle: nil)
    
    // MARK: - Properties

    // Long-lived dependencies
    let sharedUserSessionRepository: UserSessionRepository
    let sharedMainViewModel: MainViewModel
    let sharedCampaignsRepository: CampaignsRepository

    public init() {
        
        func makeUserSessionRepository() -> UserSessionRepository {
            let dataStore = makeUserSessionDataStore()
            let remoteAPI = makeAuthRemoteAPI()
            return LeadLinkUserSessionRepository.init(dataStore: dataStore, remoteAPI: remoteAPI)
        }

        func makeUserSessionDataStore() -> UserSessionDataStore {
            
            return FileUserSessionDataStore()

        }

        func makeAuthRemoteAPI() -> AuthRemoteAPI {
            return LeadLinkRemoteAPI.init()
        }

        func makeMainViewModel() -> MainViewModel {
            return MainViewModel()
        }
        
        // campaigns
        
        func makeCampaignsRepository() -> CampaignsRepository {
            
            //let userSession = sharedUserSessionRepository.readUserSession().value!! // oprez - ne valja ovo mislim....
            let userSession = makeUserSessionRepository().readUserSession().value
            let dataStore = RealmCampaignsDataStore.init()
            let remoteAPI = LeadLinkCampaignsRemoteAPI.shared
            
            return CampaignsRepository.init(userSession: userSession,
                                             dataStore: dataStore,
                                             remoteAPI: remoteAPI)
        }
        
        self.sharedUserSessionRepository = makeUserSessionRepository()
        self.sharedMainViewModel = makeMainViewModel()
        self.sharedCampaignsRepository = makeCampaignsRepository()

    }
    
    // Main
    // Factories needed to create a MainViewController.
    
        func makeLogoutViewController() -> LogoutVC {
            
            // ovde mozes da mu property inject recimo viewmodel, ili fabriku ili sta treba:
            return sb.instantiateViewController(withIdentifier: "LogoutVC") as! LogoutVC
            
        }

}

    // MARK: - Methods
//    public init() {
//        func makeUserSessionRepository() -> UserSessionRepository {
//            let dataStore = makeUserSessionDataStore()
//            let remoteAPI = makeAuthRemoteAPI()
//            return KooberUserSessionRepository(dataStore: dataStore,
//                                               remoteAPI: remoteAPI)
//        }
//
//        func makeUserSessionDataStore() -> UserSessionDataStore {
//            #if USER_SESSION_DATASTORE_FILEBASED
//            return FileUserSessionDataStore()
//
//            #else
//            let coder = makeUserSessionCoder()
//            return KeychainUserSessionDataStore(userSessionCoder: coder)
//            #endif
//        }
//
//        func makeUserSessionCoder() -> UserSessionCoding {
//            return UserSessionPropertyListCoder()
//        }
//
//        func makeAuthRemoteAPI() -> AuthRemoteAPI {
//            return FakeAuthRemoteAPI()
//        }
//
//        // Because `MainViewModel` is a concrete type
//        //  and because `MainViewModel`'s initializer has no parameters,
//        //  you don't need this inline factory method,
//        //  you can also initialize the `sharedMainViewModel` property
//        //  on the declaration line like this:
//        //  `let sharedMainViewModel = MainViewModel()`.
//        //  Which option to use is a style preference.
//        func makeMainViewModel() -> MainViewModel {
//            return MainViewModel()
//        }
//
//        self.sharedUserSessionRepository = makeUserSessionRepository()
//        self.sharedMainViewModel = makeMainViewModel()
//    }
//
//    // Main
//    // Factories needed to create a MainViewController.
//
//    public func makeMainViewController() -> MainViewController {
//        let launchViewController = makeLaunchViewController()
//
//        let onboardingViewControllerFactory = {
//            return self.makeOnboardingViewController()
//        }
//
//        let signedInViewControllerFactory = { (userSession: UserSession) in
//            return self.makeSignedInViewController(session: userSession)
//        }
//
//        return MainViewController(viewModel: sharedMainViewModel,
//                                  launchViewController: launchViewController,
//                                  onboardingViewControllerFactory: onboardingViewControllerFactory,
//                                  signedInViewControllerFactory: signedInViewControllerFactory)
//    }
//
//    // Launching
//
//    public func makeLaunchViewController() -> LaunchViewController {
//        return LaunchViewController(launchViewModelFactory: self)
//    }
//
//    public func makeLaunchViewModel() -> LaunchViewModel {
//        return LaunchViewModel(userSessionRepository: sharedUserSessionRepository,
//                               notSignedInResponder: sharedMainViewModel,
//                               signedInResponder: sharedMainViewModel)
//    }
//
//    // Onboarding (signed-out)
//    // Factories needed to create an OnboardingViewController.
//
//    public func makeOnboardingViewController() -> OnboardingViewController {
//        let dependencyContainer = KooberOnboardingDependencyContainer(appDependencyContainer: self)
//        return dependencyContainer.makeOnboardingViewController()
//    }
//
//    // Signed-in
//
//    public func makeSignedInViewController(session: UserSession) -> SignedInViewController {
//        let dependencyContainer = makeSignedInDependencyContainer(session: session)
//        return dependencyContainer.makeSignedInViewController()
//    }
//
//    public func makeSignedInDependencyContainer(session: UserSession) -> KooberSignedInDependencyContainer  {
//        return KooberSignedInDependencyContainer(userSession: session, appDependencyContainer: self)
//    }
//}
