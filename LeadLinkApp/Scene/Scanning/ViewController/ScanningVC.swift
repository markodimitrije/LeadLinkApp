//
//  ScanningVC.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation

class ScanningVC: UIViewController, Storyboarded {

    @IBOutlet weak var contentViewToTopSafeAreaConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewToBottomSafeAreaConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var barCodeTxtField: UITextField! { didSet { barCodeTxtField.textColor = .black } }
    
    @IBOutlet weak var scanBarcodeBtn: UIButton!
    @IBOutlet weak var orLabel: UILabel!
    
    var scannerView: QRcodeView!
    
    var spinnerViewManager: SpinnerViewManaging!
    
    private var scanner: MinimumScanning!
    
    private var campaign: Campaign? {
        return viewModel.campaign
    }
    
    var viewModel: ScanningViewModel!
    var keyboardManager: MovingKeyboardDelegate?
    
    private let disclaimerFactory = DisclaimerViewFactory()
    
    private var lastScanedCode: String = ""
    private var hasConsent = false
    
    private let questionsAnswersVcFactory = QuestionsAnswersViewControllerFactory(appDependancyContainer: factory)
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() { super.viewDidLoad()
        
        barCodeTxtField.delegate = self
        barCodeTxtField.returnKeyType = .done
        
        spinnerViewManager = SpinnerViewManager(ownerViewController: self)
        
        hookUpCameraAccordingToScanditPermission() // mogu li ovde nekako OCP ?
        
        loadKeyboardManager()
        bindUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated)
        startCamera()
    }
    
    override func viewWillDisappear(_ animated: Bool) { super.viewWillDisappear(animated)
        stopCamera()
    }
    
    private func startCamera() {
        scanner.startScanning()
    }
    
    private func stopCamera() {
        scanner.stopScanning()
    }
    
    private func hookUpCameraAccordingToScanditPermission() {
        
        loadScannerView()
        
        let scanditAllownessValidator = ScanditAllownessValidator(campaign: campaign)
        let scannerFactory = ScannerFactory(scannerVC: self,
                                            scanditAllownesValidator: scanditAllownessValidator)
        self.scanner = scannerFactory.scanner
    }
    
    private func loadScannerView() { // QRCodeView
        let scannerViewFactory = ScannerViewFactory()
        self.scannerView = scannerViewFactory.createScannerView(inView: self.view,
                                                                handler: hideScaningView)
        self.scannerView.isHidden = true
        self.view.addSubview(self.scannerView)
    }
    
    private func bindUI() {
        
        logoImageView?.image = viewModel?.logo
        
        scanBarcodeBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: { _ in
            self.scannerView.isHidden = false // show avSession (camera) view
            self.barCodeTxtField.resignFirstResponder() // dismiss barCodeTxtField and keyboard if any
        }).disposed(by: disposeBag)
        
        keyboardManager?.keyboardActive
            .filter {$0}
            .bind(to: scannerView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func hideScaningView() {
        self.scannerView.isHidden = true
    }
    
    private func loadKeyboardManager() {
        let movingKeyboardDelegateFactory = MovingKeyboardDelegateFactory.init()
        keyboardManager = movingKeyboardDelegateFactory.create { [weak self] verticalShift in
            self?.updateConstraintsDueTo(keyboardVerticalShift: verticalShift)
        }
    }
    
    private func updateConstraintsDueTo(keyboardVerticalShift verticalShift: CGFloat) {
        self.contentViewToTopSafeAreaConstraint!.constant += verticalShift
        self.contentViewToBottomSafeAreaConstraint!.constant -= verticalShift
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func navigateToQuestionsScreen() {
        let questionsVC = questionsAnswersVcFactory.makeVC(scanningViewModel: viewModel,
                                                           hasConsent: self.hasConsent)
        navigationController?.pushViewController(questionsVC, animated: true)
    }
    
    private func codeSuccessfull(code: String) {
        
        self.lastScanedCode = code // save state
        self.hideScaningView()
        
        connectedToInternet()
            .take(1)
            .subscribe(onNext: { [weak self] hasConnection in
                guard let sSelf = self else {return}
                if hasConnection {
                    sSelf.fetchDelegateAndProceedToQuestions(code: code)
                } else {
                    sSelf.consent(hasConsent: true)
                }
            }).disposed(by: disposeBag)
    }
    
    private func fetchDelegateAndProceedToQuestions(code: String) {
        
        spinnerViewManager.showSpinnerView()
        DelegatesRemoteAPI.shared.getDelegate(withCode: code)
            .subscribe(onNext: { [weak self] delegate in
                guard let sSelf = self else {return}
                sSelf.spinnerViewManager.removeSpinnerView()
                DispatchQueue.main.async {
                    let diclaimerValidator = ShowDisclaimerValidator(code: code,
                                                                     delegate: delegate,
                                                                     campaign: sSelf.campaign)
                    if diclaimerValidator.shouldShowDisclaimer(disclaimerAlreadyOnScreen: sSelf.isDisclaimerAlreadyOnScreen()) {
                        sSelf.showDisclaimer()
                    } else {
                        sSelf.consent(hasConsent: true)
                    }
                }
        }, onError: { [weak self] err in
            guard let sSelf = self else {return}
            DispatchQueue.main.async {
                sSelf.spinnerViewManager.removeSpinnerView()
                sSelf.consent(hasConsent: true) // timeout 1001 !!
            }
        })
            .disposed(by: disposeBag)
    }
 
    private func showDisclaimer() {
        guard let disclaimerView = disclaimerFactory.create(campaign: campaign) else {
            return
        }
        disclaimerView.delegate = self
        disclaimerView.tag = 12
        disclaimerView.textView.delegate = self // envy.. but doesnt work from xib (url, links)..
        self.view.addSubview(disclaimerView)
    }
    
    private func failed() {
        
        self.alert(alertInfo: AlertInfo.getInfo(type: .noCamera), sourceView: orLabel)
            .subscribe {
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func isDisclaimerAlreadyOnScreen() -> Bool {
        return self.view.subviews.first(where: {$0.tag == 12}) != nil
    }
 
    fileprivate func notifyWorldAboutScanedCode() { // print("prosledi code report za code = \(code)....")
        viewModel.codeInput.onNext(self.lastScanedCode)
        navigateToQuestionsScreen()
    }
    
    private let disposeBag = DisposeBag()
}

extension ScanningVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        found(code: textField.text ?? "")
        return true
    }
}

extension ScanningVC: BarcodeListening {
    
    func found(code: String) {
        
        scanner?.stopScanning()
        codeSuccessfull(code: code)
        self.barCodeTxtField.text = ""
        
    }
    
}

extension ScanningVC: ConsentAproving {
    func consent(hasConsent consent: Bool) {
        self.hasConsent = consent
        notifyWorldAboutScanedCode()
        removeDisclaimerView()
    }
    
    private func removeDisclaimerView() {
        if let disclaimerView = self.view.subviews.first(where: {$0.tag == 12}) {
            disclaimerView.removeFromSuperview()
        }
    }
}

extension ScanningVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if (URL.absoluteString == Constants.PrivacyPolicy.navusUrl ||
            URL.absoluteString != "") {
            UIApplication.shared.open(URL)
        }
        return false
    }
}
