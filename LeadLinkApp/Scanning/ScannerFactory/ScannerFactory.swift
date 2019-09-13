//
//  ScannerFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 13/09/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import UIKit

protocol ScannerFactoryProtocol {
    var scanner: MinimumScanning {get set}
}

/*
struct ScannerFactory: ScannerFactoryProtocol {
    
    var scanner: MinimumScanning
    var scannerView: QRcodeView
    
    init(scannerView: QRcodeView, scanditAllownesValidator: ScanditAllownessValidator) {
        
        self.scannerView = scannerView
        
        if scanditAllownesValidator.canUseScandit() {
            loadScanditScannerAndPlaceItsCaptureViewIntoCameraViewOnQRCodeView()
        } else {
            loadNativeScannerAndPlaceItsCaptureViewIntoCameraViewOnQRCodeView()
        }
    }
    
    private func loadScanditScannerAndPlaceItsCaptureViewIntoCameraViewOnQRCodeView() {
        
//        let myScanner = ScanditScanner(frame: self.scannerView.bounds, barcodeListener: self)
//
//        scanner = myScanner
//        let captureView = myScanner.captureView
//        self.scannerView.cameraView.addSubview(captureView)
        
    }
    
    private func loadNativeScannerAndPlaceItsCaptureViewIntoCameraViewOnQRCodeView() {
        
//        scanner = NativeScanner(avSessionViewModel: AVSessionViewModel(),
//                                scannerView: self.scannerView,
//                                barcodeListener: self)
    }
}
*/
