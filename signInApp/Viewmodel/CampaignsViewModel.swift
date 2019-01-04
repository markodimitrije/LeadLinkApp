//
//  CampaignsViewModel.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 04/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift

import PromiseKit

public class CampaignsViewModel {
    
    // MARK: - Properties
    let campaignsRepository: CampaignsRepository
    //let campaignsReadyResponder: CampaignsReadyResponder
    
    // MARK: - Methods
    public init(campaignsRepository: CampaignsRepository) {//,
//                campaignsReadyResponder: CampaignsReadyResponder) {
        self.campaignsRepository = campaignsRepository
//        self.campaignsReadyResponder = campaignsReadyResponder
    }
    
    @objc
    public func getCampaignsFromWeb() { // neko ti trazi da download-ujes i persist...
        
        guard let session = campaignsRepository.userSession, let userSession = session else {
            return
        }
        
        campaignsRepository.readCampaigns(userSession: userSession)
            .done { [weak self] campaigns in guard let sSelf = self else {return}
                guard campaigns.count != 0 else {return}
                print("imam campaigns.count = \(campaigns.count)")
                print("prvo ih snimi na disk preko Promise")
                print("pa im skini slike iz urls")

//                let _ = sSelf.userSessionRepository
//                    .signOut(userSession: session)
//                    .ensure { [weak self] in guard let sSelf = self else {return}
//                        print("u ensure (ili gde treba) je obrisi - implement me")
//                        sSelf.notSignedInResponder.notSignedIn()
//                }
        }
    }
    
//    @objc
//    public func signIn() {
//        indicateSigningIn()
//        let (email, password) = getEmailPassword()
//        userSessionRepository.signIn(email: email, password: password)
//            .done(signedInResponder.signedIn(to:))
//            .catch(indicateErrorSigningIn)
//            .finally { [weak self] in guard let sSelf = self else {return}
//                sSelf.enableInputs()
//        }
//    }
    
    
}
