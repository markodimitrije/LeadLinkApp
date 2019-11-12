//
//  AVCaptureDeviceExtension.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 04/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import AVFoundation
import UIKit

extension AVCaptureDevice {
    static func cameraPosition() -> AVCaptureDevice.Position? {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .front
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            return .back
        }
        return nil
    }
}
