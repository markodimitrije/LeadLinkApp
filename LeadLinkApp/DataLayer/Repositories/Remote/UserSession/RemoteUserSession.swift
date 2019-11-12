//
//  RemoteUserSession.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 30/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

public struct RemoteUserSession: Codable {
    
    // MARK: - Properties
    let credentials: LoginCredentials
    let token: AuthToken
    
    // MARK: calculated vars
    var email: String {
        return credentials.email
    }
    var pass: String {
        return credentials.password
    }
    
    // MARK: - Methods
    public init(credentials: LoginCredentials, token: AuthToken) {
        self.credentials = credentials
        self.token = token
    }

}

extension RemoteUserSession: Equatable {
    
    public static func ==(lhs: RemoteUserSession, rhs: RemoteUserSession) -> Bool {
        return lhs.token == rhs.token
    }
}
