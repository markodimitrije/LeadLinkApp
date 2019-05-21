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

class ScanningVC: UIViewController, Storyboarded {

    @IBOutlet weak var contentViewToTopSafeAreaConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewToBottomSafeAreaConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var barCodeTxtField: UITextField!
    
    @IBOutlet weak var scanBarcodeBtn: UIButton!
    @IBOutlet weak var orLabel: UILabel!
    
    var scannerView: QRcodeView!
    var avSessionViewModel = AVSessionViewModel()
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
        
    }
    
    private func bindQrAndBarScanCamera() {
        loadScannerView()
        bindAVSession()
        bindCamera()
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
    
    // camera session binding:
    
    private func bindAVSession() {
        
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
    
    private func bindCamera() {
        
        avSessionViewModel.oCode.throttle(1.9, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (barCodeValue) in
                guard let sSelf = self else {return}
                print("scanner camera emituje barCodeValue \(barCodeValue)")
                sSelf.found(code: barCodeValue)
            })
            .disposed(by: disposeBag)
        
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
    
    private func codeSuccessfull(code: String) { // print("prosledi code report za code = \(code)....")
        //print("codeSuccessfull.stopRunning()")
        avSessionViewModel.captureSession.stopRunning()
    
        viewModel.codeInput.onNext(code)
        
        navigateToQuestionsScreen()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //print("viewWillAppear.startRunning()")
        self.avSessionViewModel.captureSession.startRunning()
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
// GDE OVO

class DataAccess {
    static let shared = DataAccess.init()
}
