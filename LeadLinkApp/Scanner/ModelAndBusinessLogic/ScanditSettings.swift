//
//  ScanditSettings.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 12/07/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import Foundation
import ScanditBarcodeCapture

protocol BarcodeCaptureSettingsProviding {
    var settings: BarcodeCaptureSettings {get set}
}

class NavusLicenseBarcodeCaptureSettingsProvider: BarcodeCaptureSettingsProviding {
    
    private let symbologies = Set<Symbology>.init(arrayLiteral: .aztec, .code128, .code25, .code39, .dataMatrix, .ean8, .ean13UPCA, .pdf417, .qr, .upce)
    
    var settings: BarcodeCaptureSettings
    
    init() {
        
        self.settings = BarcodeCaptureSettings()
        
        self.enableSimbologiesAvailableByLicense()
        self.expandBarcodeCharactersDefaultRange()
        
    }
    
    private func enableSimbologiesAvailableByLicense() {
        
        _ = self.symbologies.map {
            self.settings.set(symbology: $0, enabled: true)
        }
        
    }
    
    private func expandBarcodeCharactersDefaultRange() {
     
        _ = self.symbologies.map {
                let symbologySettings = settings.settings(for: $0)
                let newActiveSymbolCounts = Set<NSNumber>.init(arrayLiteral: 2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20)
                symbologySettings.activeSymbolCounts = newActiveSymbolCounts
        }
        
    }
    
}

/* ovaj ima sve ysmbologies - nemamo takvu licencu...
class BarcodeCaptureSettingsProvider: BarcodeCaptureSettingsProviding {
    var settings: BarcodeCaptureSettings
    init() {
        
        let settings = BarcodeCaptureSettings()
        
        settings.set(symbology: .codabar, enabled: true)
        settings.set(symbology: .code11, enabled: true)
        settings.set(symbology: .code25, enabled: true)
        settings.set(symbology: .code32, enabled: true)
        settings.set(symbology: .code39, enabled: true)
        settings.set(symbology: .code93, enabled: true)
        settings.set(symbology: .code128, enabled: true)
        settings.set(symbology: .codabar, enabled: true)
        settings.set(symbology: .interleavedTwoOfFive, enabled: true)
        settings.set(symbology: .dataMatrix, enabled: true)
        settings.set(symbology: .ean8, enabled: true)
        settings.set(symbology: .ean13UPCA, enabled: true)
        settings.set(symbology: .upce, enabled: true)
        settings.set(symbology: .msiPlessey, enabled: true)
        settings.set(symbology: .qr, enabled: true)
        settings.set(symbology: .microQR, enabled: true)
        settings.set(symbology: .microPDF417, enabled: true)
        settings.set(symbology: .pdf417, enabled: true)
        settings.set(symbology: .aztec, enabled: true)
        settings.set(symbology: .maxiCode, enabled: true)
        settings.set(symbology: .dotCode, enabled: true)
        settings.set(symbology: .kix, enabled: true)
        settings.set(symbology: .rm4scc, enabled: true)
        settings.set(symbology: .gs1Databar, enabled: true)
        settings.set(symbology: .gs1DatabarExpanded, enabled: true)
        settings.set(symbology: .gs1DatabarLimited, enabled: true)
        settings.set(symbology: .lapa4SC, enabled: true)
        
        
        let symbologySettings = settings.settings(for: .code128)
        let newActiveSymbolCounts = Set<NSNumber>.init(arrayLiteral: 2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)
        symbologySettings.activeSymbolCounts = newActiveSymbolCounts
        
        self.settings = settings
    }
}
*/
