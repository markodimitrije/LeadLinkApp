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
import RxRealm
import RxRealmDataSources

class LogoutVC: UIViewController { // rename u campaignsVC a logout funkcionalnost izmesti negde drugde (popUp sa show-hide logout i stats)
    
    @IBOutlet weak var tableView: UITableView!
    
    let dataStore = FileUserSessionDataStore.init() // oprez - cuvas u fajlu umesto u keychain-u ili negde gde je secure...
    var repository: LeadLinkUserSessionRepository!
    //let factory = AppDependencyContainer.init() // ima ref na MainViewModel (responder za signIn signOut state)
    var factory: AppDependencyContainer!
    
    var logOutViewModel: LogOutViewModel!
    var campaignsViewModel: CampaignsViewModel!
    
    var notSignedInResponder: NotSignedInResponder { // ovo je ultra bez veze....
        return factory.sharedMainViewModel
    }
    
    
    // MARK: - campaigns outputs
    
    fileprivate let selRealmCampaign = PublishSubject<RealmCampaign>()
    
    var selectedRealmCampaign: Observable<RealmCampaign> { // exposed selectedRealmCampaign
        return selRealmCampaign.asObservable()
    }
    
    @IBAction func logOutTapped(_ sender: UIButton) {
        
        logOutViewModel.signOut()
        
    }
    
    override func viewDidLoad() { super.viewDidLoad()
        
        tableView.delegate = self
        
        repository = LeadLinkUserSessionRepository.init(dataStore: dataStore, remoteAPI: LeadLinkRemoteAPI.shared)
        logOutViewModel = LogOutViewModel.init(userSessionRepository: repository, notSignedInResponder: notSignedInResponder)
        campaignsViewModel = CampaignsViewModel.init(campaignsRepository: factory.sharedCampaignsRepository)
        
        observe(userSessionState: factory.sharedMainViewModel.view) // bind VC to listen for signedIn event (from mainViewModel):
        
        bindUI()
        
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
    
    private func bindUI() { // bind dataSource
        
        let dataSource = RxTableViewRealmDataSource<RealmCampaign>(cellIdentifier:"cell", cellType: CampaignCell.self)
        { cell, _, rCampaign in
            print("item/ campaign name = \(rCampaign.name)")
            let campaign = Campaign.init(realmCampaign: rCampaign)
            cell.update(campaign: campaign)
        }
        
        campaignsViewModel.oCampaigns
            .bind(to: tableView.rx.realmChanges(dataSource))
            .disposed(by: disposeBag)
        
    }
    
    private let disposeBag = DisposeBag.init()
    
}



extension LogoutVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCampaign = campaignsViewModel.getCampaign(forSelectedTableIndex: indexPath.item)
        
        selRealmCampaign.onNext(selectedCampaign)
        
        print("navigate to new screen, snimi da je izabrana kampanja = \(selectedCampaign.name)")
        //navigationController?.popViewController(animated: true)
        
    }
}
