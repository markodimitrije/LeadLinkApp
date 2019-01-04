//
//  File.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 30/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import PromiseKit

public protocol AuthRemoteAPI {
    //func logIn(email: String, password: String) -> Promise<UserSession>
    func logIn(credentials: LoginCredentials) -> Promise<UserSession>
    func logOut(userSession: UserSession) -> Promise<UserSession>
}

public protocol RemoteAPI {
    func getCampaigns(userSession: UserSession) -> Promise<[Campaign]>
    //func getQuestions(campaignId id: Int) -> Promise<[Question]>
}
