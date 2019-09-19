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
import RealmSwift

class ScanningVC: UIViewController, Storyboarded {

    @IBOutlet weak var contentViewToTopSafeAreaConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewToBottomSafeAreaConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var barCodeTxtField: UITextField! { didSet { barCodeTxtField.textColor = .black } }
    
    @IBOutlet weak var scanBarcodeBtn: UIButton!
    @IBOutlet weak var orLabel: UILabel!
    
    var scannerView: QRcodeView!
    
    private var scanner: MinimumScanning!
    
    private var campaign: Campaign? // imas observera koji ce te sync sa realm...
    private let _obsCampaign = factory.sharedCampaignsRepository.fetchCampaign(selectedCampaignId ?? 0)

    //let _obsCampaign = RealmSelectedCampaign.init(campaignsDataStore: factory.sharedCampaignsRepository.dataStore).selectedCampaign() // pises ono sto vec imas .... !?
    
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
        
        observeCampaign()
        
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
    
    private func observeCampaign() {
        _obsCampaign.subscribe(onNext: { realmCampaign in
            self.campaign = Campaign.init(realmCampaign: realmCampaign)
        }).disposed(by: disposeBag)
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
        
        DelegatesRemoteAPI.shared.getDelegate(withCode: code)
            .subscribe(onNext: { [weak self] delegate in
                guard let sSelf = self else {return}
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
            }).disposed(by: disposeBag)
    }
    
    private func showDisclaimer() {
        let disclaimerUrl = campaign?.settings?.disclaimer?.url ?? ""
        let disclaimerTxt = campaign?.settings?.disclaimer?.text ?? ""
        
        if let disclaimerView = disclaimerFactory.create() {
            disclaimerView.delegate = self
            disclaimerView.tag = 12
            disclaimerView.configureTxtView(withText: disclaimerTxt, url: disclaimerUrl)
            disclaimerView.textView.delegate = self // envy.. but doesnt work from xib (url, links)..
            self.view.addSubview(disclaimerView)
        }
    }
    
    private func failed() { //print("failed.....")
        
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
