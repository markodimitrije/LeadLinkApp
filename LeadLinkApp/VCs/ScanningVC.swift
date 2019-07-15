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
import ScanditBarcodeScanner

class ScanningVC: UIViewController, Storyboarded {

    @IBOutlet weak var contentViewToTopSafeAreaConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewToBottomSafeAreaConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var barCodeTxtField: UITextField! { didSet { barCodeTxtField.textColor = .black } }
    
    @IBOutlet weak var scanBarcodeBtn: UIButton!
    @IBOutlet weak var orLabel: UILabel!
    
    var scannerView: QRcodeView!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    private var scanner: Scanning!
    private let scanditAllownessValidator: ScanditAllownessValidator = {
        let campaignId = UserDefaults.standard.value(forKey: "campaignId") as? Int ?? 0 // hard-coded
        let campaign = factory.sharedCampaignsRepository.dataStore.readCampaign(id: campaignId)
        let validation = ScanditAllownessValidator(campaign: campaign.value)
        return validation
    }()
    
    private let avSessionViewModel = AVSessionViewModel()
    
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
        
        hookUpCameraAccordingToScanditPermission()
        
        loadKeyboardManager()
        bindUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated)
        startCameraIfNoScanditLicense()
        restartScanditCameraForScaning()
    }
    
    override func viewWillDisappear(_ animated: Bool) { super.viewWillDisappear(animated)
        stopCameraIfNoScanditLicense()
    }
    
    // MARK: - Scandit or Native camera support
    
    private func startCameraIfNoScanditLicense() {
        //self.avSessionViewModel.captureSession.startRunning()
        if !scanditAllownessValidator.canUseScandit() {
            self.avSessionViewModel.captureSession.startRunning()
        }
    }
    
    private func stopCameraIfNoScanditLicense() {
        if !scanditAllownessValidator.canUseScandit() {
            self.avSessionViewModel.captureSession.stopRunning()
        }
    }
    
    private func stopScanditCamera() {
        scanner?.stopScanning()
    }
    
    private func hookUpCameraAccordingToScanditPermission() {
        loadScannerView()
        
        // hard-coded off
        if scanditAllownessValidator.canUseScandit() {//kScanditBarcodeScannerAppKey != nil {
            bindQrAndBarScanCameraScandit() // ovde treba provera da li postoji scanditKey - hard-coded
        } else {
            bindQrAndBarScanCameraNative()
        }
    }
    
    private func bindQrAndBarScanCameraScandit() {
        setupScanditScanner()
    }
    
    private func bindQrAndBarScanCameraNative() {
        bindSessionUsingAVSessionViewModel()
        bindCameraUsingAVSessionViewModel()
    }
    
    // SCANDIT
    
    private func setupScanditScanner() {
        
        scanner = ScanditScanner(frame: self.scannerView.bounds, barcodeListener: self)
        self.scannerView.addSubview(scanner.captureView)
        
    }
    
    // native camera session binding:
    
    private func bindSessionUsingAVSessionViewModel() {
        
        avSessionViewModel.oSession
            .subscribe(onNext: { [unowned self] (session) in
                
                let previewLayer = CameraPreviewLayer(session: session,
                                                      bounds: self.scannerView.layer.bounds)
                
                self.scannerView.attachCameraForScanning(previewLayer: previewLayer)
                
                }, onError: { [unowned self] err in
                    self.failed()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindCameraUsingAVSessionViewModel() {
        
        //avSessionViewModel.oCode.throttle(1.9, scheduler: MainScheduler.instance)
        avSessionViewModel.oCode
            .subscribe(onNext: { [weak self] (barCodeValue) in
                guard let sSelf = self else {return}
                print("scanner camera emituje barCodeValue \(barCodeValue)")
                sSelf.found(code: barCodeValue)
            })
            .disposed(by: disposeBag)
        
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
    
    private func loadScannerView() {
        let scannerViewFactory = ScannerViewFactory()
        let cameraView = scannerViewFactory.createCameraView(inScannerView: self.view,
                                                             handler: hideScaningView)
        self.scannerView = cameraView
        self.scannerView.isHidden = true
        self.view.addSubview(cameraView)
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
        
        if !disclaimerIsAlreadyOnScreen() {
            showDisclaimer()
        }
        
    }
    
    private func showDisclaimer() {
        
        if let disclaimerView = disclaimerFactory.create() {
            disclaimerView.delegate = self
            disclaimerView.tag = 12
            disclaimerView.configureTxtViewWithHyperlinkText()
            disclaimerView.textView.delegate = self // envy.. but doesnt work from xib (url, links)..
            self.view.addSubview(disclaimerView)
        }
    }
    
    private func failed() { print("failed.....")
        
        self.alert(alertInfo: AlertInfo.getInfo(type: .noCamera), sourceView: orLabel)
            .subscribe {
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func failedDueToNoCodeDetected() { print("failedDueToNoCodeDetected. prikazi alert....")
        
        self.alert(alertInfo: AlertInfo.getInfo(type: .noCodeDetected), sourceView: orLabel)
            .subscribe {
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func restartScanditCameraForScaning() {
        scanner?.startScanning()
    }
    
    private func disclaimerIsAlreadyOnScreen() -> Bool {
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
            URL.absoluteString == Constants.PrivacyPolicy.url) {
            UIApplication.shared.open(URL)
        }
        return false
    }
}

extension ScanningVC: BarcodeListening {
    
    func found(code: String) {
        
        scanner?.stopScanning()
        stopCameraIfNoScanditLicense()
        
        codeSuccessfull(code: code)
        
    }

}
