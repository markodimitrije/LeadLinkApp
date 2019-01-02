//
//  SignInViewModel.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 30/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift

import Foundation
import RxSwift

public class LogInViewModel {
    
    // MARK: - Properties
    let userSessionRepository: UserSessionRepository
    let signedInResponder: SignedInResponder
    
    // MARK: - Methods
    public init(userSessionRepository: UserSessionRepository,
                signedInResponder: SignedInResponder) {
        self.userSessionRepository = userSessionRepository
        self.signedInResponder = signedInResponder
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
        
        print("error = \(error)")
        
        errorMessagesSubject.onNext(errorMessage)
        
        emailInputEnabled.onNext(true)
        passwordInputEnabled.onNext(true)
        signInButtonEnabled.onNext(true)
        
        // (*) ovo je kvarno, jer si trebao kao handler u OK na alert-u (secas da si remove tu func....)
        delay(0.5) { [weak self] in // mali trik da se emituje malo kasnije jer se vidi "gap" u promeni text-a pre nego iskoci alert
            guard let sSelf = self else {return}
            sSelf.signInActivityIndicatorAnimating.onNext(false)
        }
        
    }
}

public protocol SignedInResponder {
    func signedIn(to userSession: UserSession)
}

//// trik da bih zadrzao logiku na VC (bez ovoga ima mali gap izmedju set title i show alert)
