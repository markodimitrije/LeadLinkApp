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

class LoginViewController: UIViewController {

    let dataStore = FileUserSessionDataStore.init() // oprez - cuvas u fajlu umesto u keychain-u ili negde gde je secure...
    var repository: LeadLinkUserSessionRepository!
    //let responder = MainViewModel.init()
    var logInViewModel: LogInViewModel!
    let factory = AppDependencyContainer.init() // ima ref na MainViewModel (responder za signIn signOut state)
    var keyboardManager: MovingKeyboardDelegate?
    
    @IBOutlet weak var loginStackView: UIStackView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var loginStackViewYConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func loginTapped(_ sender: UIButton) {
       
        logInViewModel.signIn() // uzima ono sto je u txtBoxes... (viewmodel prati state na vc.view)
        
    }
    
    override func awakeFromNib() {
        repository = LeadLinkUserSessionRepository.init(dataStore: dataStore, remoteAPI: LeadLinkRemoteAPI.shared)
        logInViewModel = LogInViewModel.init(userSessionRepository: repository, signedInResponder: factory.sharedMainViewModel)
    }
    
    override func viewDidLoad() { super.viewDidLoad()
        
        bindViews(to: logInViewModel)
        
        bindActualSessionToCredentialFields()
        
        observe(userSessionState: factory.sharedMainViewModel.view) // bind VC to listen for signedIn event (from mainViewModel):
        
        observeErrorMessages(viewmodel: logInViewModel)
        
        formatControls()
        
        keyboardManager = MovingKeyboardDelegate.init(keyboardChangeHandler: { (verticalShift) in
            self.loginStackViewYConstraint!.constant += verticalShift
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        })
        
    }
    
    private func bindViews(to viewmodel: LogInViewModel) {
        
        // bind UI to viewmodel:
        bindEmailField()
        bindPasswordField()
        
        // bind viewmodel to UI:
        bindActivityIndicator()
        bindViewModelToEmailField()
        bindViewModelToPasswordField()
        bindViewModelToLogInButton()
        
    }

    
    private func bindEmailField() { // VC -> viewmodel
        emailField.rx.text
            .asDriver()
            .map { $0 ?? "" }
            .drive(logInViewModel.emailInput)
            .disposed(by: disposeBag)
    }
    
    private func bindPasswordField() { // VC -> viewmodel
        passField.rx.text
            .asDriver()
            .map { $0 ?? "" }
            .drive(logInViewModel.passwordInput)
            .disposed(by: disposeBag)
    }
    
    private func bindActivityIndicator() { // viewmodel -> VC
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
    
    private func bindViewModelToEmailField() {
        logInViewModel
            .emailInputEnabled
            .asDriver(onErrorJustReturn: true)
            .drive(emailField.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModelToPasswordField() {
        logInViewModel
            .passwordInputEnabled
            .asDriver(onErrorJustReturn: true)
            .drive(passField.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModelToLogInButton() {
        logInViewModel
            .signInButtonEnabled
            .asDriver(onErrorJustReturn: true)
            .drive(logInBtn.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    private func bindActualSessionToCredentialFields() { // ako nije logout, prikazi mu
        
        logInViewModel.emailInput
            .asDriver(onErrorJustReturn: "")
            .drive(emailField.rx.text)
            .disposed(by: disposeBag)
        
        logInViewModel.passwordInput
            .asDriver(onErrorJustReturn: "")
            .drive(passField.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func observeErrorMessages(viewmodel: LogInViewModel) {
        logInViewModel
            .errorMessages
            .asDriver { _ in fatalError("Unexpected error from error messages observable.") }
            .drive(onNext: { [weak self] errorMessage in guard let strongSelf = self else { return }
                strongSelf.present(errorMessage: errorMessage)
            })
            .disposed(by: disposeBag)
    }
    
    private func observe(userSessionState: Observable<MainViewState>) {
        userSessionState
            //.debug()
            .skip(1)
            .subscribe(onNext: { [weak self] state in
                print("emitujem state = \(state)")
                guard let sSelf = self else {return}
                switch state {
                case .signedIn(let userSession):
                    sSelf.presentSignedIn(userSession: userSession)
                    sSelf.downloadCampaigns()
                case .signOut:
                    sSelf.logInViewModel.userLogedOut()
                }
            }).disposed(by: disposeBag)
    }
    
    private func presentSignedIn(userSession: UserSession) {
        
        let campaignsVC = factory.makeCampaignsViewController()
        campaignsVC.factory = factory
        
        navigationController?.pushViewController(campaignsVC, animated: true)
    }
    
    private func downloadCampaigns() {
        
        if let appdel = UIApplication.shared.delegate as? AppDelegate {
            appdel.downloadCampaignsQuestionsAndLogos()
        }
        
    }
    
    private func formatControls() {
        activityIndicator.isHidden = true
        logInBtn.layer.cornerRadius = 17.0
    }
    
    private let disposeBag = DisposeBag.init()

}

//struct FakeSignedInResponder: SignedInResponder {
//    func signedIn(to userSession: UserSession) {
//        print("FakeSignedInResponder.signedIn imam token: \(userSession.remoteSession.token)")
//        print("FakeSignedInResponder.signedIn implement me.....")
//        print("skini kampanje, save ih na disk, itd....")
//    }
//
//
//}

