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

class ScanningVC: UIViewController {

    @IBOutlet weak var contentViewToTopSafeAreaConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewToBottomSafeAreaConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var barCodeTxtField: UITextField!
    
    @IBOutlet weak var confirmBarcodeBtn: UIButton! // treba za iPad
    @IBOutlet weak var scanBarcodeBtn: UIButton!
    
    var scannerView: QRcodeView!
    lazy private var scanerViewModel = ScannerViewModel.init(dataAccess: DataAccess.shared)
    let avSessionViewModel = AVSessionViewModel()
    var previewLayer: AVCaptureVideoPreviewLayer!
    private (set) var scanedCode = BehaviorSubject<String>.init(value: "")
    
    var viewModel: ScanningViewModel!
    var keyboardManager: MovingKeyboardDelegate?
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewDidLoad() { super.viewDidLoad()
        
        barCodeTxtField.delegate = self
        
        bindQrAndBarScanCamera()
        
        loadKeyboardManager()
        bindUI()
        
        //bindQrAndBarScanCamera()
    }
    
    private func bindQrAndBarScanCamera() {
        loadScannerView()
        bindAVSession()
        bindBarCode()
    }
    
    private func bindUI() {
        
        logoImageView?.image = viewModel?.logo
        
        barCodeTxtField.rx.text.asDriver()
            .map { $0 ?? "" }
            .drive(viewModel.codeInput)
            .disposed(by: disposeBag)
        
        confirmBarcodeBtn?.rx.controlEvent(.touchUpInside).asDriver()
            .drive(self.rx.dismissKeyboard)
            .disposed(by: disposeBag)
        
        scanBarcodeBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: { _ in
            self.scannerView.isHidden = false // show avSession (camera) view
            self.barCodeTxtField.resignFirstResponder() // dismiss barCodeTxtField and keyboard if any
        }).disposed(by: disposeBag)

        keyboardManager?.keyboardActive.filter {$0}.map {_ in return()}
            .bind(to: scannerView.rx.dismiss)
            .disposed(by: disposeBag)

    }
    
    private func loadScannerView() {

        let frame = getRectForQrCodeView(center: self.view.center)
        
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
    
    private func bindBarCode() {
        
        avSessionViewModel.oCode
            .subscribe(onNext: { [weak self] (barCodeValue) in
                guard let sSelf = self else {return}
                
                sSelf.found(code: barCodeValue)
            })
            .disposed(by: disposeBag)
        
    }
    
    func found(code: String) { // ovo mozes da report VM-u kao append novi code
        
        if scanerViewModel.sessionId != -1 {
            codeSuccessfull(code: code)
        } else {
            failedDueToNoSettings()
        }
        
    }
    
    private func failed() { print("failed.....")
        
        self.alert(title: Constants.AlertInfo.ScanningNotSupported.title,
                   text: Constants.AlertInfo.ScanningNotSupported.msg,
                   btnText: Constants.AlertInfo.ok)
            .subscribe {
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func failedDueToNoSettings() {
        
        print("failedDueToNoSettings. prikazi alert....")
        
        self.alert(title: Constants.AlertInfo.NoSettings.title,
                   text: Constants.AlertInfo.NoSettings.msg,
                   btnText: Constants.AlertInfo.ok)
            .subscribe {
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func codeSuccessfull(code: String) {
        
        avSessionViewModel.captureSession.stopRunning()
        
        if self.scannerView.subviews.contains(where: {$0.tag == 20}) {
            //            print("vec prikazuje arrow, izadji...")
            return
        } // already arr
        
        scanedCode.onNext(code)
        print("scanned code = \(code), dojavi viewmodel-u + navigate na questions/answers")
        
//        let qrAnimView = getArrowImgView(frame: scannerView.qrCodeView.bounds)
//        qrAnimView.tag = 20
        
//        self.scannerView.qrCodeView.addSubview(qrAnimView)
//
        delay(2.0) { // ovoliko traje anim kada prikazujes arrow
            DispatchQueue.main.async {
                //self.scannerView.qrCodeView.subviews.first(where: {$0.tag == 20})?.removeFromSuperview()
                self.avSessionViewModel.captureSession.startRunning()
            }
        }
        
        print("prosledi code report....")
        //codeReporter.codeReport.accept(getActualCodeReport())
        
    }
    
    private let disposeBag = DisposeBag()
}

extension ScanningVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print("entered code = \(try! viewModel.codeInput.value())")
        return true
    }
}










// GDE OVO:

struct CodeReport {
    var code: String
    var sessionId: Int
    var date: Date
}

class CodeReportsState {}

class ScannerViewModel {
    
    var dataAccess: DataAccess
    
    var sessionId = 0
    var sessionName: PublishSubject<String> = PublishSubject.init()
    var sessionInfo: PublishSubject<String> = PublishSubject.init()
    
    init(dataAccess: DataAccess) {
        self.dataAccess = dataAccess
    }
}

class DataAccess {
    static let shared = DataAccess.init()
}

//func getArrowImgView(frame: CGRect) -> UIImageView {
//    let imageView = UIImageView.init(frame: getFrameForQrCodeView())
//    imageView.image = UIImage.init(named: "QR_code")
//    return imageView
//}

func getSizeForQrCodeView() -> CGSize {
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    let side = min(width, height)
    return CGSize.init(width: 0.6*side, height: 0.6*side)
    
}

func getRectForQrCodeView(center: CGPoint) -> CGRect {
    
    return CGRect.init(center: center, size: getSizeForQrCodeView())
    
}

extension CGRect {
    var center: CGPoint {
        return CGPoint.init(x: self.origin.x - self.size.width/2, y: self.origin.y - self.size.height/2)
    }
    init(center: CGPoint, size: CGSize) {
        let orig = CGPoint.init(x: center.x - size.width/2, y: center.y - size.height/2)
        let rect = CGRect.init(origin: orig, size: size)
        self = rect
    }
}
