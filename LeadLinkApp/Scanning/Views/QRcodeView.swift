//
//  QRcodeView.swift
//  tryJustScan
//
//  Created by Marko Dimitrijevic on 12/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import AVFoundation

class QRcodeView: UIView {
    
    @IBOutlet weak var cameraView: UIView!
    
    @IBAction func btnTapped(_ sender: UIButton) {
        btnTapHandler?()
    }
    
    var btnTapHandler: (() -> ())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    convenience init(frame: CGRect, btnTapHandler: @escaping () -> ()) {
        self.init(frame: frame)
        self.btnTapHandler = btnTapHandler
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "QRcodeView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(view)
        
    }
    
    func attachCameraForScanning(previewLayer: AVCaptureVideoPreviewLayer) {
//        self.qrCodeView?.layer.addSublayer(previewLayer)
        let layer = previewLayer
        layer.frame.origin = CGPoint.init(x: 0, y: 0)
        self.cameraView?.layer.addSublayer(layer)
        
    }
    
}
