//
//  NativeScanner.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 18/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

// MARK:- ScanningProtocols Implementations

class NativeScanner: NSObject, MinimumScanning {
    
    private var avSessionViewModel: AVSessionViewModel
    internal var barcodeListener: BarcodeListening
    
    private let disposeBag = DisposeBag()
    
    func startScanning() {
        self.avSessionViewModel.captureSession.startRunning()
    }
    
    func stopScanning() {
        self.avSessionViewModel.captureSession.stopRunning()
    }
    
    init(avSessionViewModel: AVSessionViewModel, scannerView: QRcodeView, barcodeListener: BarcodeListening) {
        // load private vars
        self.avSessionViewModel = avSessionViewModel
        self.barcodeListener = barcodeListener
        
        super.init()
        
        attachCameraToScannerView(scannerView: scannerView)
        listenBarcodes()
        
    }
    
    private func attachCameraToScannerView(scannerView: QRcodeView) {
        
        avSessionViewModel.oSession
            .subscribe(onNext: { (session) in
                
                let previewLayer = CameraPreviewLayer(session: session,
                                                      bounds: scannerView.layer.bounds)
                
                scannerView.attachCameraForScanning(previewLayer: previewLayer)
                
            })
            .disposed(by: disposeBag)
    }
    
    private func listenBarcodes() {
        avSessionViewModel.oCode
            .subscribe(onNext: { [weak self] (barCodeValue) in
                guard let sSelf = self else {return}
                print("scanner camera emituje barCodeValue \(barCodeValue)")
                sSelf.barcodeFound(barCodeValue)
            })
            .disposed(by: disposeBag)
    }
    
    
}

extension NativeScanner {
    func barcodeFound(_ barcode: String) {
        
        DispatchQueue.main.async { [weak self] in
            
            self?.barcodeListener.found(code: barcode)
            
        }
    }
}
