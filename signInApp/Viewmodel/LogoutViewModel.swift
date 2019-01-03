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
                guard let session = session else {return}
                print("imam pravu sesiju, email = \(session.remoteSession.email)")
                let _ = sSelf.userSessionRepository
                    .signOut(userSession: session)
                    .ensure { [weak self] in guard let sSelf = self else {return}
                        print("u ensure (ili gde treba) je obrisi - implement me")
                        sSelf.notSignedInResponder.notSignedIn()
            }
        }
    }
}
