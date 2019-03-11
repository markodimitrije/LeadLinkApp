//
//  SignInViewModel.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 30/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift

import PromiseKit

public class LogInViewModel {
    
    // MARK: - Properties
    let userSessionRepository: UserSessionRepository
    let signedInResponder: SignedInResponder
    
    // MARK: - Methods
    public init(userSessionRepository: UserSessionRepository,
                signedInResponder: SignedInResponder) {
        self.userSessionRepository = userSessionRepository
        self.signedInResponder = signedInResponder
        loadInitialSession()
    }
    
    public let emailInput = BehaviorSubject<String>(value: "")
    public let passwordInput = BehaviorSubject<Secret>(value: "")
    
    public var errorMessages: Observable<ErrorMessage> {
        return errorMessagesSubject.asObserver()
    }
    public let errorMessagesSubject = PublishSubject<ErrorMessage>()
    
    public let emailInputEnabled = BehaviorSubject<Bool>(value: true)
    public let passwordInputEnabled = BehaviorSubject<Bool>(value: true)
    public let signInButtonEnabled = BehaviorSubject<Bool>(value: true)
    public let signInActivityIndicatorAnimating = BehaviorSubject<Bool>(value: false)
    
    @objc
    public func signIn() {
        indicateSigningIn()
        let (email, password) = getEmailPassword()
        userSessionRepository.signIn(email: email, password: password)
            .done(signedInResponder.signedIn(to:))
            .catch(indicateErrorSigningIn)
            .finally { [weak self] in guard let sSelf = self else {return}
                sSelf.enableInputs()
        }
    }
    
    func indicateSigningIn() {
        emailInputEnabled.onNext(false)
        passwordInputEnabled.onNext(false)
        signInButtonEnabled.onNext(false)
        signInActivityIndicatorAnimating.onNext(true)
    }
    
    func getEmailPassword() -> (String, Secret) {
        do {
            let email = try emailInput.value()
            let password = try passwordInput.value()
            return (email, password)
        } catch {
            fatalError("Error reading email and password from behavior subjects.")
        }
    }
    
    func indicateErrorSigningIn(_ error: Error) {
        
        var errorMessage: ErrorMessage!
        if let err = error as? RemoteAPIError {
            errorMessage = err.translateToErrorMessage()
        } else {
            errorMessage = ErrorMessage(title: "Sign In Failed",
                                        message: error.localizedDescription)
        }
        
        errorMessagesSubject.onNext(errorMessage)
        
        enableInputs()
        
    }
    
    private func enableInputs() {
        delay(0.5) { [weak self] in // jer se update pre nego se prikaze alert (u slucaju da ima error)
            guard let sSelf = self else {return}
            sSelf.emailInputEnabled.onNext(true)
            sSelf.passwordInputEnabled.onNext(true)
            sSelf.signInButtonEnabled.onNext(true)
            sSelf.signInActivityIndicatorAnimating.onNext(false)
        }
    }
    
    private func loadInitialSession() {
        userSessionRepository
            .readUserSession()
            .done { [weak self] (session) in
                guard let sSelf = self else {return}
                print("loadInitialSession.session emituje = \(session.remoteSession.email)")
                sSelf.emailInput.onNext(session.remoteSession.email)
                sSelf.passwordInput.onNext(session.remoteSession.pass)
            }
            .catch {_ in }
    }
    
    func userLogedOut() {
        print("userLogedOut is called")
        emailInput.onNext("")
        passwordInput.onNext("")
    }

    
}

//// trik da bih zadrzao logiku na VC (bez ovoga ima mali gap izmedju set title i show alert)
