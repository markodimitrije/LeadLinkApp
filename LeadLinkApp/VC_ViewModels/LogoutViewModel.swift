//
//  LogoutViewModel.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 03/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import PromiseKit

protocol Logoutable {
    func signOut()
}

class LogOutViewModel: Logoutable {
    
    // MARK: - Properties
    let userSessionRepository: UserSessionRepositoryProtocol
    let notSignedInResponder: NotSignedInResponder
    let mutableCampaignsRepo: ICampaignsMutableRepository
    
    // MARK: - Methods
    init(userSessionRepository: UserSessionRepositoryProtocol,
                notSignedInResponder: NotSignedInResponder,
                mutableCampaignsRepo: ICampaignsMutableRepository) {
        self.userSessionRepository = userSessionRepository
        self.notSignedInResponder = notSignedInResponder
        self.mutableCampaignsRepo = mutableCampaignsRepo
    }
    
    @objc
    public func signOut() {
        
        userSessionRepository.readUserSession()
            .done { [weak self] session in guard let sSelf = self else {return}
                print("logout.OK, email = \(session.remoteSession.email)")
                let _ = sSelf.userSessionRepository
                    .signOut(userSession: session)
                    .ensure { [weak self] in guard let sSelf = self else {return}
                        sSelf.notSignedInResponder.notSignedIn()
                        sSelf.deleteConfApiKeyStateAndAuthorization()
                        sSelf.mutableCampaignsRepo.deleteCampaignRelatedData()
                }
            }
    }
    
    private func deleteConfApiKeyStateAndAuthorization() {
        UserDefaults.standard.setValue(nil, forKey: UserDefaults.keyConferenceAuth)
        confApiKeyState = nil
    }
    
}
