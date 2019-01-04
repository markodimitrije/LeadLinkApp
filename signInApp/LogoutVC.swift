//
//  LogoutVC.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 03/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import PromiseKit
import RxCocoa
import RxSwift

class LogoutVC: UIViewController {
    
    let dataStore = FileUserSessionDataStore.init() // oprez - cuvas u fajlu umesto u keychain-u ili negde gde je secure...
    var repository: LeadLinkUserSessionRepository!
    //let factory = AppDependencyContainer.init() // ima ref na MainViewModel (responder za signIn signOut state)
    var factory: AppDependencyContainer!
    
    var logOutViewModel: LogOutViewModel!
    
    var notSignedInResponder: NotSignedInResponder { // ovo je ultra bez veze....
        return factory.sharedMainViewModel
    }
    
    @IBAction func logOutTapped(_ sender: UIButton) {
        
        logOutViewModel.signOut()
        
    }
    
    @IBAction func getCampaignsTapped(_ sender: UIButton) { // oprez - samo za bekend..
        
        print("zovi svoj viewmodel da ti da podatke")
        
        let campaignsViewmodel = CampaignsViewModel.init(campaignsRepository: factory.sharedCampaignsRepository)
        
        campaignsViewmodel.getCampaignsFromWeb()
        
        
    }
    
    
    
    override func viewDidLoad() { super.viewDidLoad()
        
        repository = LeadLinkUserSessionRepository.init(dataStore: dataStore, remoteAPI: LeadLinkRemoteAPI.shared)
        logOutViewModel = LogOutViewModel.init(userSessionRepository: repository, notSignedInResponder: notSignedInResponder)
        observe(userSessionState: factory.sharedMainViewModel.view) // bind VC to listen for signedIn event (from mainViewModel):
        
    }
    
    private func observe(userSessionState: Observable<MainViewState>) { // navigation...
        userSessionState
            .skip(1) // jer je inicijano set-ovan na signOut
            .subscribe(onNext: { [weak self] state in
                guard let sSelf = self else {return}
                switch state {
                case .signOut:
                    sSelf.navigateToRootVC()
                default: break
                }
            }).disposed(by: disposeBag)
    }
    
    private func navigateToRootVC() {
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    private let disposeBag = DisposeBag.init()
    
    
    
}
