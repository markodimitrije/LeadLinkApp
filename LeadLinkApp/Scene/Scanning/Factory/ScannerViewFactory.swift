//
//  ScannerViewFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 02/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class ScannerViewFactory {
    
    func createScannerView(inView view: UIView, handler: @escaping () -> ()) -> QRcodeView {
        
        var loadedScannerView = view
        
        let frame = QRcodeView.getRectForQrCodeView(center: loadedScannerView.center)
        
        let qrCodeView = QRcodeView.init(frame: frame, btnTapHandler: handler)
        
        loadedScannerView = qrCodeView
        loadedScannerView.isHidden = true
        
        return qrCodeView
        
    }
    
}
