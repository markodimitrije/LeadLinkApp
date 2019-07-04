//
//  AVCaptureSessionError.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 04/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

enum AVCaptureSessionError: Error {
    case noVideoCaptureDevice
    case noVideoInput
    case cantAddInputToSession
    case cantAddOutputToSession
    case cantDetermineCameraPosition
}
