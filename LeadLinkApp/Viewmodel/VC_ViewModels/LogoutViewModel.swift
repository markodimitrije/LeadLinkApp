//
//  LogoutViewModel.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 03/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift

import PromiseKit

public class LogOutViewModel {
    
    // MARK: - Properties
    let userSessionRepository: UserSessionRepository
    let notSignedInResponder: NotSignedInResponder
    
    private let campaignsDataStore = AppDependencyContainer().sharedCampaignsRepository
    private let realmCampaignsDataStore = RealmCampaignsDataStore.init()
    
    // MARK: - Methods
    public init(userSessionRepository: UserSessionRepository,
                notSignedInResponder: NotSignedInResponder) {
        self.userSessionRepository = userSessionRepository
        self.notSignedInResponder = notSignedInResponder
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
                        sSelf.deleteCampaignRelatedData()
                }
        }
    }
    
    private func deleteCampaignRelatedData() {
        RealmDataPersister.shared.deleteAllObjects(ofTypes: [RealmCampaign.self,
                                                             RealmOrganization.self,
                                                             RealmSetting.self,
                                                             RealmQuestion.self,
                                                             RealmApplication.self,
                                                             RealmJson.self])
    }
    
}
