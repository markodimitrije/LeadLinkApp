//
//  ScanditBarcodePickerFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 02/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import ScanditBarcodeScanner

class ScanditBarcodePickerFactory {
    
    func createPicker(inRect rect: CGRect) -> SBSBarcodePicker {
        let settings = SBSScanSettings.default()
        let symbologies: Set<SBSSymbology> = [.aztec, .codabar, .code11, .code128, .code25, .code32, .code39, .code93, .datamatrix, .dotCode, .ean8, .ean13, .fiveDigitAddOn, .gs1Databar, .gs1DatabarExpanded, .gs1DatabarLimited, .itf, .kix, .lapa4sc, .maxiCode, .microPDF417, .microQR, .msiPlessey, .pdf417,.qr, .rm4scc, .twoDigitAddOn, .upc12, .upce]
        for symbology in symbologies {
            settings.setSymbology(symbology, enabled: true)
        }
        
        settings.cameraFacingPreference = getCameraDeviceDirection() ?? .back
        
        let symSettings = settings.settings(for: .code25)
        symSettings.activeSymbolCounts = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
        
        // Create the barcode picker with the settings just created
        let barcodePicker = SBSBarcodePicker(settings:settings)
        
        barcodePicker.view.frame = rect
        
        barcodePicker.overlayController.drawViewfinder(false) // depricated...
        
        return barcodePicker
    }
}
