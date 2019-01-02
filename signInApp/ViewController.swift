//
//  ViewController.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 30/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import PromiseKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    let dataStore = FileUserSessionDataStore.init()
    var repository: LeadLinkUserSessionRepository!
    let responder = FakeSignedInResponder.init()
    var logInViewModel: LogInViewModel!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var logInBtn: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.isHidden = true
        }
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
       
        logInViewModel.signIn() // uzima ono sto je u txtBoxes... (viewmodel prati state na vc.view)
        
    }
    
    override func awakeFromNib() {
        repository = LeadLinkUserSessionRepository.init(dataStore: dataStore, remoteAPI: LeadLinkRemoteAPI.shared)
        logInViewModel = LogInViewModel.init(userSessionRepository: repository, signedInResponder: responder)
    }
    
    override func viewDidLoad() { super.viewDidLoad()
        
        bindViews(to: logInViewModel)
        
        observeErrorMessages(viewmodel: logInViewModel)
    }
    
    private func bindViews(to viewmodel: LogInViewModel) {
        
        // bind UI to viewmodel:
        bindEmailField(viewmodel: viewmodel)
        bindPasswordField(viewmodel: viewmodel)
        
        // bind viewmodel to UI:
        bindActivityIndicator(viewmodel: viewmodel)
        bindViewModelToEmailField(viewmodel: viewmodel)
        bindViewModelToPasswordField(viewmodel: viewmodel)
        bindViewModelToLogInButton(viewmodel: viewmodel)
    }

    
    private func bindEmailField(viewmodel: LogInViewModel) { // VC -> viewmodel
        emailField.rx.text
            .asDriver()
            .map { $0 ?? "" }
            .drive(logInViewModel.emailInput)
            .disposed(by: disposeBag)
    }
    
    private func bindPasswordField(viewmodel: LogInViewModel) { // VC -> viewmodel
        passField.rx.text
            .asDriver()
            .map { $0 ?? "" }
            .drive(logInViewModel.passwordInput)
            .disposed(by: disposeBag)
    }
    
    private func bindActivityIndicator(viewmodel: LogInViewModel) { // viewmodel -> VC
        let activityDriver = logInViewModel
            .signInActivityIndicatorAnimating
            .asDriver(onErrorJustReturn: false)
        activityDriver
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        activityDriver
            .map { return $0 ? "" : "Log In" }
            .drive(logInBtn.rx.title(for: .normal))
            .disposed(by: disposeBag)
    }
    
    private func bindViewModelToEmailField(viewmodel: LogInViewModel) {
        logInViewModel
            .emailInputEnabled
            .asDriver(onErrorJustReturn: true)
            .drive(emailField.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModelToPasswordField(viewmodel: LogInViewModel) {
        logInViewModel
            .passwordInputEnabled
            .asDriver(onErrorJustReturn: true)
            .drive(passField.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModelToLogInButton(viewmodel: LogInViewModel) {
        logInViewModel
            .signInButtonEnabled
            .asDriver(onErrorJustReturn: true)
            .drive(logInBtn.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    private func observeErrorMessages(viewmodel: LogInViewModel) {
        logInViewModel
            .errorMessages
            .asDriver { _ in fatalError("Unexpected error from error messages observable.") }
            .drive(onNext: { [weak self] errorMessage in
                guard let strongSelf = self else { return }
                strongSelf.present(errorMessage: errorMessage)
            })
            .disposed(by: disposeBag)
    }
    
    private let disposeBag = DisposeBag.init()

}

struct FakeSignedInResponder: SignedInResponder {
    func signedIn(to userSession: UserSession) {
        print("FakeSignedInResponder.signedIn imam token: \(userSession.remoteSession.token)")
        print("FakeSignedInResponder.signedIn implement me.....")
        print("skini kampanje, save ih na disk, itd....")
    }
    
    
}
