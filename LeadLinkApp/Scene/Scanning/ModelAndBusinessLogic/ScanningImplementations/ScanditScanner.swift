//
//  Scanning.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 12/07/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import UIKit
import ScanditCaptureCore
import ScanditBarcodeCapture

// MARK:- ScanningProtocols Implementations

//class ScanditScanner: NSObject, Scanning {
class ScanditScanner: NSObject, MinimumScanning, ScanViewProviding {
    
    func startScanning() {
        camera?.switch(toDesiredState: .on)
    }
    
    func stopScanning() {
        camera?.switch(toDesiredState: .off)
    }
    
    internal var barcodeListener: BarcodeListening
    var captureView: UIView
    
    private var camera: Camera!
    
    required init(frame: CGRect, barcodeListener: BarcodeListening) {
        
        self.barcodeListener = barcodeListener
        
        let context = DataCaptureContext(licenseKey: kScanditBarcodeScannerAppKey)
        let settings = NavusLicenseBarcodeCaptureSettingsProvider().settings
        let barcodeCapture = BarcodeCapture(context: context, settings: settings)
        
        let cameraPosition = getCameraDeviceDirection() ?? .worldFacing
        
        camera = Camera.init(position: cameraPosition)
        context.setFrameSource(camera, completionHandler: nil)
        
        let captureView = DataCaptureView(for: context, frame: frame)
        
        captureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let overlay = BarcodeCaptureOverlay(barcodeCapture: barcodeCapture)
        captureView.addOverlay(overlay)
        
        self.captureView = captureView
        
        super.init()
        
        barcodeCapture.addListener(self)
    }
    
}

extension ScanditScanner: BarcodeCaptureListener {
    
    func barcodeCapture(_ barcodeCapture: BarcodeCapture,
                        didScanIn session: BarcodeCaptureSession,
                        frameData: FrameData) {

        let code = session.newlyRecognizedBarcodes[0]
        
        DispatchQueue.main.async { [weak self] in

            self?.barcodeListener.found(code: code.data)

        }
    }
    
}
