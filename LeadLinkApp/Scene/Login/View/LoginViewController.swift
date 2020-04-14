//
//  ViewController.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 30/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LoginViewController: UIViewController, Storyboarded {

    var logInViewModel: LogInViewModel!
    
    private var keyboardManager: MovingKeyboardDelegate?
    
    private let campaignsVcFactory = CampaignsViewControllerFactory.init(appDependancyContainer: factory)
    
    @IBOutlet weak var loginStackView: UIStackView!
    @IBOutlet weak var emailField: UITextField! {
        didSet {
//            emailField.text = "medibeacon@mailinator.com"
//            emailField.text = "biorad@mailinator.com"
            emailField.text = "nestle@mailinator.com"
        }
    }
    @IBOutlet weak var passField: UITextField! {
        didSet {
//            passField.text = "ERAEDTA2019"
            passField.text = "timm2019"
        }
    }
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var loginStackViewYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func loginTapped(_ sender: UIButton) {
       
        logInViewModel.signIn() // uzima ono sto je u txtBoxes... (viewmodel prati state na vc.view)
        
    }
    
    override func viewDidLoad() { super.viewDidLoad()
        
        bindViews(to: logInViewModel)
        
        bindActualSessionToCredentialFields()
        
        observe(userSessionState: factory.sharedMainViewModel.userSessionStateObservable) // bind VC to listen for signedIn event (from mainViewModel):
        
        observeErrorMessages(viewmodel: logInViewModel)
        
        formatControls()
        
        keyboardManager = MovingKeyboardDelegate.init(keyboardChangeHandler: { (verticalShift) in

            if verticalShift > 0 {
                self.loginStackViewYConstraint!.constant = CGFloat(0) // budi tu gde jesi...
            } else {
                self.loginStackViewYConstraint!.constant = -abs(verticalShift) // podigni se za keyboardHeight/2 pt
            }
            
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
        bindViewModelStateToControlsIsEnabledProperty()
        
    }

    // MARK:- bind isEnabled
    private func bindViewModelStateToControlsIsEnabledProperty() {
        bindViewModelToEmailFieldIsEnabled()
        bindViewModelToPasswordFieldIsEnabled()
        bindViewModelToLogInButtonIsEnabled()
    }
    
    private func bindViewModelToEmailFieldIsEnabled() {
        logInViewModel
            .emailInputEnabled
            .asDriver(onErrorJustReturn: true)
            .drive(emailField.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModelToPasswordFieldIsEnabled() {
        logInViewModel
            .passwordInputEnabled
            .asDriver(onErrorJustReturn: true)
            .drive(passField.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModelToLogInButtonIsEnabled() {
        logInViewModel
            .signInButtonEnabled
            .asDriver(onErrorJustReturn: true)
            .drive(logInBtn.rx.isEnabled)
            .disposed(by: disposeBag)
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
            .map { return $0 ? "" : Constants.BtnTitles.logIn }
            .drive(logInBtn.rx.title(for: .normal))
            .disposed(by: disposeBag)
    }
    
    private func bindActualSessionToCredentialFields() { // viewmodel -> VC
        
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
    
    private func observe(userSessionState: Observable<UserState>) {
        userSessionState
            //.debug()
            .skip(1)
            .subscribe(onNext: { [weak self] state in
                print("emitujem state = \(state)")
                guard let sSelf = self else {return}
                switch state {
                case .signedIn(let userSession):
                    sSelf.onSignedInNavigateToCampaignsVC(userSession: userSession)
                    sSelf.downloadCampaigns()
                case .signOut:
                    sSelf.logInViewModel.userIsLogedOutClearTxtFields()
                }
            }).disposed(by: disposeBag)
    }
    
    private func onSignedInNavigateToCampaignsVC(userSession: UserSession) {
        let campaignsVC = campaignsVcFactory.makeVC()
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
