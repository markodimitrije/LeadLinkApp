//
//  AVSessionViewModel.swift
//  tryScanner
//
//  Created by Marko Dimitrijevic on 31/10/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import AVFoundation
import UIKit
import RxSwift
import RxCocoa

class AVSessionViewModel {
    
    private (set) var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    let delegate = RxAVCaptureMetadataCaptureDelegate.init()
    
    // OUTPUT
    
    var oSession: BehaviorSubject<AVCaptureSession>!
    
    private var code = PublishSubject<String>.init()
    var oCode: Observable<String> {
        return code.asObservable()
    }
    
    init() {
        
        configureSession()
        configureDelegate()
        
    }
    
    private func configureSession() {
        
        captureSession = AVCaptureSession()
        oSession = BehaviorSubject<AVCaptureSession>.init(value: captureSession)

        guard let cameraPosition = AVCaptureDevice.cameraPosition() else {
            oSession.onError(AVCaptureSessionError.cantDetermineCameraPosition)
            return
        }
        
        let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                         for: AVMediaType.video,
                                                         position: cameraPosition)
        
        guard let cameraDevice = videoCaptureDevice else {
            print("AVSessionViewModel.init. no videoCaptureDevice");
            oSession.onError(AVCaptureSessionError.noVideoCaptureDevice)
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: cameraDevice)
        } catch {
            print("AVSessionViewModel.init. no videoCaptureDevice ")
            oSession.onError(AVCaptureSessionError.noVideoInput)
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            oSession.onError(AVCaptureSessionError.cantAddInputToSession)
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.upce, .code128, .ean8, .ean13, .itf14, .qr]
            
        } else {
            oSession.onError(AVCaptureSessionError.cantAddOutputToSession)
            return
        }
        
        oSession.onNext(captureSession)
        
    }
    
    private func configureDelegate() {
        
        // configure actions on avSession output // imas metadata.....
        
        delegate.observer = AnyObserver<MetadataCaptureOutput>.init(eventHandler: {
            [unowned self] (event) in
            
            guard let metadataObjects = event.element?.metadataObjects else {
                print("err. nemam metadataObjects. . .. . .. ")
                return
            }
            
            self.captureSession.stopRunning() // stop actual session
            
            guard let metadataObject = metadataObjects.first,
                let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                let stringValue = readableObject.stringValue else {
                    print("guard-else... readableObject....")
                    return
            }
            // all good...
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            self.code.onNext(stringValue)
            
        })
    }
    
}

enum AVCaptureSessionError: Error {
    case noVideoCaptureDevice
    case noVideoInput
    case cantAddInputToSession
    case cantAddOutputToSession
    case cantDetermineCameraPosition
}

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
