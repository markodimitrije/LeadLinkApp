//
//  ScanningProtocols.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 12/07/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import UIKit
//import ScanditCaptureCore
//import ScanditBarcodeCapture

protocol BarcodeListening {
    func found(code: String)
}

// MARK:- Scan Protocols

protocol StartStopScanningProtocol {
    func startScanning()
    func stopScanning()
}
protocol ScanedBarcodeForwarding {
    var barcodeListener: BarcodeListening {get set}
}
protocol ScanViewProviding {
    var captureView: UIView {get set} // view to be added to VCs placeholder view
}

protocol Scanning: StartStopScanningProtocol, ScanedBarcodeForwarding, ScanViewProviding {}

protocol MinimumScanning: StartStopScanningProtocol, ScanedBarcodeForwarding {}
