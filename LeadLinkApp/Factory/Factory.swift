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
            let userSessionRepository = makeUserSessionRepository()
            let dataStore = RealmCampaignsDataStore.init()
            let questionsDataStore = RealmQuestionsDataStore.init()
            let remoteAPI = LeadLinkCampaignsRemoteAPI.shared
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

    }
    
    // Viewmodels
    
    
    
    // Main
    // Factories needed to create a MainViewController.
    
    func makeLoginViewController() -> LoginViewController {
        
        return LoginViewController.instantiate(using: sb)
    }
    
    func makeCampaignsViewController() -> CampaignsVC {
        
        // ovde mozes da mu property inject recimo viewmodel, ili fabriku ili sta treba:
        //return sb.instantiateViewController(withIdentifier: "CampaignsVC") as! CampaignsVC
        let campaignsVC = CampaignsVC.instantiate(using: sb)
        campaignsVC.campaignsViewModel = makeCampaignsViewModel()
        return campaignsVC
    }
    
    func makeStatsViewController(campaignId id: Int) -> StatsVC {
        
        //let statsVC = sb.instantiateViewController(withIdentifier: "StatsVC") as! StatsVC
        let statsVC = StatsVC.instantiate(using: sb)
        statsVC.codesVC = makeCodesViewController(campaignId: id)
        statsVC.chartVC = makeChartViewController(campaignId: id)
        return statsVC
        
    }

    func makeCodesViewController(campaignId id: Int) -> CodesVC {
        
//        codesVC.codesDataSource = CodesDataSource.init(campaignId: id,
//                                                       codesDataStore: makeCodeDataStore(),
//                                                       tableView: codesVC.tableView,
//                                                       cellId: "CodeCell")
//        codesVC.codesDelegate = CodesDelegate()

        let codesDataSource = CodesDataSource.init(campaignId: id,
                                                       codesDataStore: makeCodeDataStore(),
                              //                         tableView: codesVC.tableView,
                                                       cellId: "CodeCell")
        let codesDelegate = CodesDelegate()
        
        let codesVC = sb.instantiateViewController(withIdentifier: "CodesVC") as! CodesVC
        
        codesVC.codesDataSource = codesDataSource
        codesVC.codesDelegate = codesDelegate
        
        return codesVC
        
    }
    
    func makeChartViewController(campaignId id: Int) -> UIViewController {
        
//        let codesVC = sb.instantiateViewController(withIdentifier: "CodesVC") as! CodesVC
//
//        codesVC.codesDataSource = CodesDataSource.init(campaignId: id,
//                                                       codesDataStore: makeCodeDataStore(),
//                                                       cellId: "CodesCell")
//        codesVC.codesDelegate = CodesDelegate()
        
//        return codesVC
        return UIViewController.init()
        
    }
    
    // Scanning
    
    func makeScanningViewController(viewModel: ScanningViewModel?) -> ScanningVC {
        
        //let scanningVC = sb.instantiateViewController(withIdentifier: "ScanningVC") as! ScanningVC
        let scanningVC = ScanningVC.instantiate(using: sb)
        if let viewModel = viewModel {
            scanningVC.viewModel = viewModel
        }
        return scanningVC
    }
    
    // Questions and Answers
    
    func makeQuestionsAndAnswersViewController(scanningViewModel viewModel: ScanningViewModel?) -> QuestionsAndAnswersVC {
        
        print ("makeQuestionsAndAnswersViewController.codeInput.value() = \(try! viewModel!.codeInput.value())")
        
        //let vc = sb.instantiateViewController(withIdentifier: "QuestionsAndAnswersVC") as! QuestionsAndAnswersVC
        let vc = QuestionsAndAnswersVC.instantiate(using: sb)
        if let viewModel = viewModel {
            let questionsViewModel = makeQuestionsViewModel(scanningViewmodel: viewModel)
            vc.viewModel = questionsViewModel
        }
        
        return vc
    }
    
    private func getViewControllerTypes() -> [UIViewController.Type] {
        return [LoginViewController.self,
                CampaignsVC.self,
                ScanningVC.self]
    }

    // make viewmodels
    
    func makeNavigationViewModel() -> NavigationViewModel {
        let items = [NavBarItem.stats, NavBarItem.logout]
        let viewmodel = NavigationViewModel.init(navBarItems: items,
                                                 viewControllerTypes: getViewControllerTypes(),
                                                 logOutViewModel: makeLogoutViewModel())
        return viewmodel
    }
    
    func makeLoginViewModel() -> LogInViewModel {
        let viewmodel = LogInViewModel.init(userSessionRepository: sharedUserSessionRepository, signedInResponder: self.sharedMainViewModel)
        return viewmodel
    }
    
    func makeLogoutViewModel() -> LogOutViewModel {
        
        let viewmodel = LogOutViewModel.init(userSessionRepository: sharedUserSessionRepository, notSignedInResponder: self.sharedMainViewModel)
        return viewmodel
    }
    
    func makeQuestionsViewModel(scanningViewmodel: ScanningViewModel) -> QuestionsViewmodel {
        let viewmodel = QuestionsViewmodel.init(scanningViewmodel: scanningViewmodel)
        return viewmodel
    }
    
    func makeScanningViewModel(campaign: Campaign, codesDataStore: CodesDataStore? = nil) -> ScanningViewModel {
        
        let dataStore = codesDataStore ?? makeCodeDataStore()
        let scanningViewmodel = ScanningViewModel.init(campaign: campaign, codesDataStore: dataStore)
        
        return scanningViewmodel
    }
    
    func makeCampaignsViewModel() -> CampaignsViewModel {
        return CampaignsViewModel.init(campaignsRepository: sharedCampaignsRepository)
    }
    
    // make datastore
    
    private func makeCodeDataStore() -> CodesDataStore {
        let realmCampaignsDataStore = RealmCampaignsDataStore.init()
        return RealmCodesDataStore.init(campaignsDataStore: realmCampaignsDataStore)
    }
    
    
}

// zna da li je ovaj btn visible ili ne
enum NavBarItem {
    case logout
    case stats
}

protocol Storyboarded: class {
    static func instantiate(using sb: UIStoryboard?) -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(using sb: UIStoryboard? = nil) -> Self {
        let sb = sb ?? UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let name = String(describing: self)
        return sb.instantiateViewController(withIdentifier: name) as! Self
    }
}
