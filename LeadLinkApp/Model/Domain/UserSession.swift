//
//  UserSession.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 30/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation

public class UserSession: Codable {
    
    // MARK: - Properties
    public let remoteSession: RemoteUserSession
    
    // MARK: - Methods
    public init(remoteSession: RemoteUserSession) {
        self.remoteSession = remoteSession
    }
}

extension UserSession: Equatable {
    
    public static func ==(lhs: UserSession, rhs: UserSession) -> Bool {
        return
            lhs.remoteSession == rhs.remoteSession
    }
}
