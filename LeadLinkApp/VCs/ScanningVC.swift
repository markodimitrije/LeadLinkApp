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
    @IBOutlet weak var barCodeTxtField: UITextField! {
        didSet {
            barCodeTxtField.textColor = .black
        }
    }
    
    @IBOutlet weak var scanBarcodeBtn: UIButton!
    @IBOutlet weak var orLabel: UILabel!
    
    var scannerView: QRcodeView!
    var previewLayer: AVCaptureVideoPreviewLayer!
    private var picker: SBSBarcodePicker?
    
    var viewModel: ScanningViewModel!
    var keyboardManager: MovingKeyboardDelegate?
    
    private let disclaimerFactory = DisclaimerViewFactory()
    
    private var lastScanedCode: String = ""
    private var hasConsent = false
    
    private let questionsAnswersVcFactory = QuestionsAnswersViewControllerFactory(appDependancyContainer: factory)
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewDidLoad() { super.viewDidLoad()
        
        barCodeTxtField.delegate = self
        barCodeTxtField.returnKeyType = .done
        
        bindQrAndBarScanCamera()
        loadKeyboardManager()
        bindUI()
        
        setupScanner()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if picker != nil {
            restartCameraForScaning(picker!)
        }
    }
    
    private func bindQrAndBarScanCamera() {
        loadScannerView()
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
    
    private func loadScannerView() {

        let frame = QRcodeView.getRectForQrCodeView(center: self.view.center)
        
        let qrCodeView = QRcodeView.init(frame: frame, btnTapHandler: {
                self.scannerView.isHidden = true
            })
        
        self.scannerView = qrCodeView
        self.scannerView.isHidden = true
        
        self.view.addSubview(self.scannerView)
    }
    
    private func loadKeyboardManager() {
        keyboardManager = MovingKeyboardDelegate.init(keyboardChangeHandler: { (halfKeyboardHeight) in
            var verticalShift: CGFloat = 0
            if UIDevice.current.userInterfaceIdiom == .phone {
                verticalShift = 2*halfKeyboardHeight
            } else if UIDevice.current.userInterfaceIdiom == .pad {
                verticalShift = halfKeyboardHeight
            }

            self.contentViewToTopSafeAreaConstraint!.constant += verticalShift
            self.contentViewToBottomSafeAreaConstraint!.constant -= verticalShift
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        })
    }
    
    private func navigateToQuestionsScreen() {
        let questionsVC = questionsAnswersVcFactory.makeVC(scanningViewModel: viewModel,
                                                           hasConsent: self.hasConsent)
        navigationController?.pushViewController(questionsVC, animated: true)
    }
    
    func found(code: String) { // ovo mozes da report VM-u kao append novi code

        if code != "" {
            codeSuccessfull(code: code)
        } else {
            failedDueToNoCodeDetected()
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

    // AttendanceApp hard-coded - implement me....
    func found(code: String, picker: SBSBarcodePicker) { // ovo mozes da report VM-u kao append novi code

        self.picker = picker
//        restartCameraForScaning(picker)
        codeSuccessfull(code: code)
        
    }
    
    private func restartCameraForScaning(_ picker: SBSBarcodePicker) {
//        delay(1.0) { // this is not scanner.. when it should be restarted?
//            DispatchQueue.main.async {
//                picker.resumeScanning()
//            }
//        }
        picker.resumeScanning()
    }

    private func codeSuccessfull(code: String) {
        
        self.lastScanedCode = code // save state
        
        if !disclaimerAlreadyOnScreen() {
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
    
    private func disclaimerAlreadyOnScreen() -> Bool {
        if let _ = self.view.subviews.first(where: {$0.tag == 12}) {
            return true
        } else {
            return false
        }
    }
 
    fileprivate func notifyWorldAboutScanedCode() {
        // print("prosledi code report za code = \(code)....")
        viewModel.codeInput.onNext(self.lastScanedCode)
        navigateToQuestionsScreen()
    }
    
    
    
    // SCANDIT
    
    private func setupScanner() {
        
        // Create the scan settings and enabling some symbologies
        let settings = SBSScanSettings.default()
        let symbologies: Set<SBSSymbology> = [.aztec, .codabar, .code11, .code128, .code25, .code32, .code39, .code93, .datamatrix, .dotCode, .ean8, .ean13, .fiveDigitAddOn, .gs1Databar, .gs1DatabarExpanded, .gs1DatabarLimited, .itf, .kix, .lapa4sc, .maxiCode, .microPDF417, .microQR, .msiPlessey, .pdf417,.qr, .rm4scc, .twoDigitAddOn, .upc12, .upce]
        for symbology in symbologies {
            settings.setSymbology(symbology, enabled: true)
        }
        
        settings.cameraFacingPreference = getCameraDeviceDirection() ?? .back
        
        let symSettings = settings.settings(for: .code25)
        symSettings.activeSymbolCounts = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
        
        // Create the barcode picker with the settings just created
        let barcodePicker = SBSBarcodePicker(settings:settings)
        barcodePicker.view.frame = self.scannerView.bounds

        barcodePicker.overlayController.drawViewfinder(false) // depricated...
        
        // Add the barcode picker as a child view controller
        addChild(barcodePicker)
        
        self.scannerView.cameraView.addSubview(barcodePicker.view)
        barcodePicker.didMove(toParent: self)
        
        // Set the allowed interface orientations. The value UIInterfaceOrientationMaskAll is the
        // default and is only shown here for completeness.
        barcodePicker.allowedInterfaceOrientations = .all
        // Set the delegate to receive scan event callbacks
        barcodePicker.scanDelegate = self
        barcodePicker.startScanning()
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

extension ScanningVC: SBSScanDelegate {
    // This delegate method of the SBSScanDelegate protocol needs to be implemented by
    // every app that uses the Scandit Barcode Scanner and this is where the custom application logic
    // goes. In the example below, we are just showing an alert view with the result.
    func barcodePicker(_ picker: SBSBarcodePicker, didScan session: SBSScanSession) {
        
        session.pauseScanning()
        
        let code = session.newlyRecognizedCodes[0]
        
        DispatchQueue.main.async { [weak self] in
            self?.found(code: code.data ?? "", picker: picker)
        }
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
