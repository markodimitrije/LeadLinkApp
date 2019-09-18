//
//  LogoutVC.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 03/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxRealm
import RxRealmDataSources

class CampaignsVC: UIViewController, Storyboarded { // rename u campaignsVC a logout funkcionalnost izmesti negde drugde (popUp sa show-hide logout i stats)
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:- injected by factory
    var logOutViewModel: Logoutable!
    var campaignsViewModel: CampaignsViewModel!
    var repository: UserSessionRepository!
    var notSignedInResponder: NotSignedInResponder!
    // MARK:- campaigns outputs
    // UserDefaults.standard -> trebalo je da neki dependancy....
    
    override func viewDidLoad() { super.viewDidLoad()
        
        tableView.delegate = self
        
        observe(userSessionState: factory.sharedMainViewModel.userSessionStateObservable) // bind VC to listen for signedIn event (from mainViewModel):
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
    
    private func navigateToRootVC() { //print("navigateToRootVC is called !!!")
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func bindUI() { // bind dataSource
        
        let dataSource = RxTableViewRealmDataSource<RealmCampaign>(cellIdentifier:"cell", cellType: CampaignCell.self)
        { cell, _, rCampaign in //print("item/ campaign name = \(rCampaign.name)")
            
            let campaign = Campaign.init(realmCampaign: rCampaign)
            cell.update(campaign: campaign) // ovo nije Rx, za to ti treba viewmodel: [cellViewmodel**] i na svakom ** Driver<Campaign>
        }
        
        campaignsViewModel.oCampaigns
            .bind(to: tableView.rx.realmChanges(dataSource))
            .disposed(by: disposeBag)
    }
    
    @objc private func logoutBtnTapped(_ sender: UIButton) { //Do your stuff here
        logOutViewModel.signOut()
    }
    
    private let disposeBag = DisposeBag.init()
    
}

extension CampaignsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCampaign = campaignsViewModel.getCampaign(forSelectedTableIndex: indexPath.item)
        
        //UserDefaults.standard.set(selectedCampaign.id, forKey: "campaignId")
        selectedCampaignId = selectedCampaign.id
        
        let campaign = Campaign(realmCampaign: selectedCampaign)
        
        confApiKeyState!.updateWith(selectedCampaign: campaign)
        
        let navigateToFactory = CampaignsNavigateToViewControllerFactory()
        
        if let scanningVC = navigateToFactory.getNavigationDestination(dict: ["campaignId": campaign.id]) {
            navigationController?.pushViewController(scanningVC, animated: true)
        }
    }
}
