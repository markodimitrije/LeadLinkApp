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
    var scanner: MinimumScanning! {get set}
}

class ScannerFactory: ScannerFactoryProtocol {
    
    var scanner: MinimumScanning!
    var scannerVC: ScanningVC
    
    init(scannerVC: ScanningVC, scanditAllownesValidator: ScanditAllowable) {
        
        self.scannerVC = scannerVC
        
        if scanditAllownesValidator.canUseScandit() {
            loadScanditScannerAndPlaceItsCaptureViewIntoCameraViewOnQRCodeView()
        } else {
            loadNativeScannerAndPlaceItsCaptureViewIntoCameraViewOnQRCodeView()
        }
    }
    
    private func loadScanditScannerAndPlaceItsCaptureViewIntoCameraViewOnQRCodeView() {
        
        let myScanner = ScanditScanner(frame: self.scannerVC.scannerView.bounds, barcodeListener: self.scannerVC)

        self.scanner = myScanner
        let captureView = myScanner.captureView
        self.scannerVC.scannerView.cameraView.addSubview(captureView)
 
    }
    
    private func loadNativeScannerAndPlaceItsCaptureViewIntoCameraViewOnQRCodeView() {
        
        self.scanner = NativeScanner(avSessionViewModel: AVSessionViewModel(),
                                scannerView: self.scannerVC.scannerView,
                                barcodeListener: self.scannerVC)
    }
}

