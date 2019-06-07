//
//  ScanningVC.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

//import UIKit
//import RxSwift
//import RxCocoa

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
    
    var viewModel: ScanningViewModel!
    var keyboardManager: MovingKeyboardDelegate?
    
    private let factory = AppDependencyContainer()
    
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
        let questionsVC = factory.makeQuestionsAnswersViewController(scanningViewModel: viewModel)
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

        restartCameraForScaning(picker)
        codeSuccessfull(code: code)
        
    }
    
    
    private func restartCameraForScaning(_ picker: SBSBarcodePicker) {
        delay(1.0) { // ovoliko traje anim kada prikazujes arrow
            DispatchQueue.main.async {
                picker.resumeScanning()
            }
        }
    }

    private func codeSuccessfull(code: String) { // print("prosledi code report za code = \(code)....")
        
        viewModel.codeInput.onNext(code)
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









// GDE OVO

class DataAccess {
    static let shared = DataAccess.init()
}

