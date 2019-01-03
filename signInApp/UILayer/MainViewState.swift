//
//  MainViewEnum.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 03/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

public enum MainViewState {
    
    case signedIn(userSession: UserSession)
    case signOut
    
}

extension MainViewState: Equatable {
    
    public static func ==(lhs: MainViewState, rhs: MainViewState) -> Bool {
        switch (lhs, rhs) {
        case (.signOut, .signOut):
            return true
        case let (.signedIn(l), .signedIn(r)):
            return l == r
        case (.signOut, _),
             (.signedIn, _):
            return false
        }
    }
}
