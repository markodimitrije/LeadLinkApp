//
//  SignInViewModel.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 30/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import RxSwift

public class LogInViewModel {
    
    // MARK: - Properties
    let userSessionRepository: UserSessionRepository
    let signedInResponder: SignedInResponder
    let sharedMainViewModel = AppDependencyContainer.init().sharedMainViewModel
    private let bag = DisposeBag()
    
    // MARK: - Methods
    public init(userSessionRepository: UserSessionRepository,
                signedInResponder: SignedInResponder) {
        self.userSessionRepository = userSessionRepository
        self.signedInResponder = signedInResponder
        loadInitialSession()
        listenToLogoutEvent()
    }

    public let emailInput = BehaviorSubject<String>(value: "")
    public let passwordInput = BehaviorSubject<Secret>(value: "")
    //Medibeacon
    
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
            let title = NSLocalizedString("Strings.Login.signInFailed", comment: "")
            errorMessage = ErrorMessage(title: title, message: error.localizedDescription)
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
    
    private func listenToLogoutEvent() {
        sharedMainViewModel.userSessionStateObservable.skip(1) // tamo je init sa signOut....
            .subscribe(onNext: { [weak self] state in
                if state == .signOut {
                    self?.userIsLogedOutClearTxtFields()
                }
            })
            .disposed(by: bag)
    }
    
    func userIsLogedOutClearTxtFields() { print("userLogedOut is called")
        emailInput.onNext("")
        passwordInput.onNext("")
    }
    
    deinit { print("deinit.LogInViewModel ") }
   
}
