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
        let layer = previewLayer
        layer.frame.origin = CGPoint.init(x: 0, y: 0)
        self.cameraView?.layer.addSublayer(layer)
    }
    
    static func getSizeForQrCodeView() -> CGSize {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            return getSizeForQrCodeViewOnIpad()
        } else if UIDevice.current.userInterfaceIdiom == .phone{
            return getSizeForQrCodeViewOnIphone()
        }
        return CGSize.zero
        
    }
    
    private static func getSizeForQrCodeViewOnIpad() -> CGSize {

        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height

        let side = min(width, height)
        return CGSize.init(width: 0.75*side, height: 0.75*side)

    }
    
    private static func getSizeForQrCodeViewOnIphone() -> CGSize {
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        return CGSize.init(width: 0.9*width, height: 0.9*height)
        
    }
    
    static func getRectForQrCodeView(center: CGPoint) -> CGRect {
        
        return CGRect.init(center: center, size: getSizeForQrCodeView())
        
    }
    
}
