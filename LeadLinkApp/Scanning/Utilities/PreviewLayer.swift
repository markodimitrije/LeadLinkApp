//
//  PreviewLayer.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 15/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import AVFoundation

class CameraPreviewLayer: AVCaptureVideoPreviewLayer {
    
    var deviceOrientation = UIDevice.current.orientation
    
    init(session: AVCaptureSession, frame: CGRect) {
        super.init(session: session)
        self.frame = frame
        self.videoGravity = .resizeAspectFill
        self.connection?.videoOrientation = cameraOrientation() ?? .portrait
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func cameraOrientation() -> AVCaptureVideoOrientation? {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            return .landscapeLeft
        }
        return nil
    }
    
}
