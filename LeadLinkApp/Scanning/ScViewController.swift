////
////  ViewController.swift
////  tryJustScan
////
////  Created by Marko Dimitrijevic on 12/01/2019.
////  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
////
//
//import UIKit
//import RxSwift
//import RxCocoa
//import AVFoundation
//import RealmSwift
//
//class ScViewController: UIViewController {
//
//    var scannerView: QRcodeView!
//
//    @IBAction func qrCodeTapped(_ sender: UIButton) {
//        self.scannerView.isHidden = false
//    }
//
//    lazy private var scanerViewModel = ScannerViewModel.init(dataAccess: DataAccess.shared)
//
//    let avSessionViewModel = AVSessionViewModel()
//    var previewLayer: AVCaptureVideoPreviewLayer!
//
//    private (set) var scanedCode = BehaviorSubject<String>.init(value: "")
//    var code: String {
//        return try! scanedCode.value()
//    }
//
//    private let codeReporter = CodeReportsState.init() // vrsta viewModel-a ?
//
//    // interna upotreba:
//    private let disposeBag = DisposeBag()
//
//    private func loadScannerView() {
//        let frame = getFrameForQrCodeView()
//        let qrCodeView = QRcodeView.init(frame: frame) {
//            self.scannerView.isHidden = true
//        }
//        self.scannerView = qrCodeView
//        self.scannerView.isHidden = true
//
//        self.view.addSubview(self.scannerView)
//    }
//
//    override func viewDidLoad() { super.viewDidLoad()
//
//        loadScannerView()
//
//        bindUI()
//
//        // scaner functionality
//        bindAVSession()
//        bindBarCode()
//
//    }
//
//    private func bindUI() { // glue code for selected Room
//
////        scanerViewModel.sessionName // SESSION NAME
////            .bind(to: qrCodeLbl.rx.text)
////            .disposed(by: disposeBag)
////
////        scanerViewModel.sessionInfo // SESSION INFO
////            .bind(to: barCodeLbl.rx.text)
////            .disposed(by: disposeBag)
//
//    }
//
//    private func bindAVSession() {
//
//        avSessionViewModel.oSession
//            .subscribe(onNext: { [unowned self] (session) in
//
//                self.previewLayer = AVCaptureVideoPreviewLayer(session: session)
//                self.previewLayer.frame = self.scannerView.layer.bounds
//                self.previewLayer.videoGravity = .resizeAspectFill
//                //self.previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
//
//                self.scannerView.attachCameraForScanning(previewLayer: self.previewLayer)
//
//                }, onError: { [unowned self] err in
//                    self.failed()
//            })
//            .disposed(by: disposeBag)
//    }
//
//    private func bindBarCode() {
//
//        avSessionViewModel.oCode
//            .subscribe(onNext: { [weak self] (barCodeValue) in
//                guard let sSelf = self else {return}
//
//                sSelf.found(code: barCodeValue)
//            })
//            .disposed(by: disposeBag)
//
//    }
//
//    private func failed() { print("failed.....")
//
////        self.alert(title: AlertInfo.Scan.ScanningNotSupported.title,
////                   text: AlertInfo.Scan.ScanningNotSupported.msg,
////                   btnText: AlertInfo.ok)
////            .subscribe {
////                self.dismiss(animated: true)
////            }
////            .disposed(by: disposeBag)
//    }
//
//    private func failedDueToNoSettings() {
//
//        print("failedDueToNoSettings. prikazi alert....")
//
////        self.alert(title: AlertInfo.Scan.NoSettings.title,
////                   text: AlertInfo.Scan.NoSettings.msg,
////                   btnText: AlertInfo.ok)
////            .subscribe {
////                self.dismiss(animated: true)
////            }
////            .disposed(by: disposeBag)
//    }
//
//    func found(code: String) { // ovo mozes da report VM-u kao append novi code
//
//        if scanerViewModel.sessionId != -1 {
//            codeSuccessfull(code: code)
//        } else {
//            failedDueToNoSettings()
//        }
//
//    }
//
//    private func codeSuccessfull(code: String) {
//
//        avSessionViewModel.captureSession.stopRunning()
//
//        if self.scannerView.subviews.contains(where: {$0.tag == 20}) {
//            //            print("vec prikazuje arrow, izadji...")
//            return
//        } // already arr
//
//        scanedCode.onNext(code)
//
//        let qrAnimView = getArrowImgView(frame: scannerView.qrCodeView.bounds)
//        qrAnimView.tag = 20
//
//        self.scannerView.qrCodeView.addSubview(qrAnimView)
//
//        delay(2.0) { // ovoliko traje anim kada prikazujes arrow
//            DispatchQueue.main.async {
//                self.scannerView.qrCodeView.subviews.first(where: {$0.tag == 20})?.removeFromSuperview()
//                self.avSessionViewModel.captureSession.startRunning()
//            }
//        }
//
//        print("prosledi code report....")
//        //codeReporter.codeReport.accept(getActualCodeReport())
//
//    }
//
////    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
////        return .landscape //[.landscapeLeft, .landscapeRight]
////    }
//
////    // MARK:- Private
////
////    private func getActualCodeReport() -> CodeReport {
////
////        print("getActualCodeReport = \(code)")
////
////        return CodeReport.init(code: code,
////                               sessionId: scanerViewModel.sessionId,
////                               date: Date.now)
////    }
//
//}
//
////struct CodeReport {
////    var code: String
////    var sessionId: Int
////    var date: Date
////}
////
////class CodeReportsState {}
////
////class ScannerViewModel {
////
////    var dataAccess: DataAccess
////
////    var sessionId = 0
////    var sessionName: PublishSubject<String> = PublishSubject.init()
////    var sessionInfo: PublishSubject<String> = PublishSubject.init()
////
////    init(dataAccess: DataAccess) {
////        self.dataAccess = dataAccess
////    }
////}
////
////class DataAccess {
////    static let shared = DataAccess.init()
////}
////
////func getArrowImgView(frame: CGRect) -> UIImageView {
////    let imageView = UIImageView.init(frame: getFrameForQrCodeView())
////    imageView.image = UIImage.init(named: "QR_code")
////    return imageView
////}
////
////func getFrameForQrCodeView() -> CGRect {
////
////    let width = UIScreen.main.bounds.width
////
////    return CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 0.9*width, height: 0.9*width))
////
////}
