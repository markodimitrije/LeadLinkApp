//
//  UserSessionDataStore.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 30/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import PromiseKit

public typealias AuthToken = String

public protocol UserSessionDataStore {
    
    func readUserSession() -> Promise<UserSession?>
    func save(userSession: UserSession) -> Promise<(UserSession)>
    func delete(userSession: UserSession) -> Promise<(UserSession)>
}
