//
//  MainViewModel.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 03/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift

public class MainViewModel: SignedInResponder, NotSignedInResponder {

    // MARK: - Properties
    public var userSessionStateObservable: Observable<UserState> { return viewSubject.asObservable() }
    private let viewSubject = BehaviorSubject<UserState>(value: .signOut)

    // MARK: - Methods
    public init() {}

    public func notSignedIn() {
        print("emituj .signOut iz mainViewmodel-a")
        viewSubject.onNext(.signOut)
    }

    public func signedIn(to userSession: UserSession) {
        viewSubject.onNext(.signedIn(userSession: userSession))
    }
}
