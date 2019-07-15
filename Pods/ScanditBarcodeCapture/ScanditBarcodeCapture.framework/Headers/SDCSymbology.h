/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2017- Scandit AG. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <ScanditCaptureCore/SDCBase.h>

/**
 * An enumeration of possible checksum algorithms. The enumeration only lists optional checksum algorithms; mandatory checksums that can’t be changed are not listed here. Use the values below to set optional checksums for a symbology. The exact implementation chosen depends on the symbology and checksum algorithm. Only a subset of algorithms is supported for each symbology. Check the symbology documentation to see which checksums are supported.
 */
typedef NS_OPTIONS(NSUInteger, SDCChecksum) {
/**
     * Checksum is calculated using modulo of 10.
     */
    SDCChecksumMod10 = 1 << 0,
/**
     * Checksum is calculated using modulo of 11.
     */
    SDCChecksumMod11 = 1 << 1,
/**
     * Checksum is calculated using modulo of 47.
     */
    SDCChecksumMod47 = 1 << 2,
/**
     * Checksum is calculated using modulo of 103.
     */
    SDCChecksumMod103 = 1 << 3,
/**
     * Checksum is calculated using two different modulo of 10 checksums
     */
    SDCChecksumMod10AndMod10 = 1 << 4,
/**
     * Checksum is calculated using two checksums, one using modulo of 10 and one using modulo of 11.
     */
    SDCChecksumMod10AndMod11 = 1 << 5,
/**
     * Checksum is calculated using modulo of 43.
     */
    SDCChecksumMod43 = 1 << 6,
/**
     * Checksum is calculated using modulo of 16.
     */
    SDCChecksumMod16 = 1 << 7,
} NS_SWIFT_NAME(Checksum);

/**
 * An enumeration of barcode types (symbologies) supported by the Scandit Data Capture SDK.
 *
 * The availability of the symbology depends on the licensed features.
 */
typedef NS_CLOSED_ENUM(NSUInteger, SDCSymbology) {
/**
     * EAN-13/UPC-12/UPC-A 1d barcode symbology.
     */
    SDCSymbologyEAN13UPCA NS_SWIFT_NAME(ean13UPCA),
/**
     * UPC-E 1d barcode symbology.
     */
    SDCSymbologyUPCE NS_SWIFT_NAME(upce),
/**
     * Ean8 1d barcode symbology.
     */
    SDCSymbologyEAN8 NS_SWIFT_NAME(ean8),
/**
     * Code39 1d barcode symbology.
     */
    SDCSymbologyCode39,
/**
     * Code93 1d barcode symbology.
     */
    SDCSymbologyCode93,
/**
     * Code128 1d barcode symbology.
     */
    SDCSymbologyCode128,
/**
     * Code11 1d barcode symbology.
     */
    SDCSymbologyCode11,
/**
     * Code25 1d barcode symbology.
     */
    SDCSymbologyCode25,
/**
     * Codabar 1d barcode symbology.
     */
    SDCSymbologyCodabar,
/**
     * Interleaved two of five (ITF) 1d barcode symbology.
     */
    SDCSymbologyInterleavedTwoOfFive,
/**
     * MSI-Plessey 1d barcode symbology.
     */
    SDCSymbologyMSIPlessey,
/**
     * QR Code 2D barcode symbology.
     */
    SDCSymbologyQR NS_SWIFT_NAME(qr),
/**
     * Data Matrix 2D barcode symbology.
     */
    SDCSymbologyDataMatrix,
/**
     * Aztec Code 2D barcode symbology.
     */
    SDCSymbologyAztec,
/**
     * MaxiCode 2D barcode symbology.
     */
    SDCSymbologyMaxiCode,
/**
     * Dot Code symbology.
     */
    SDCSymbologyDotCode,
/**
     * Royal Dutch TPG Post KIX.
     */
    SDCSymbologyKIX NS_SWIFT_NAME(kix),
/**
     * Royal Mail 4 State Customer Code (RM4SCC).
     */
    SDCSymbologyRM4SCC NS_SWIFT_NAME(rm4scc),
/**
     * GS1 DataBar 14 1D barcode symbology.
     */
    SDCSymbologyGS1Databar,
/**
     * GS1 DataBar Expanded 1D barcode symbology.
     */
    SDCSymbologyGS1DatabarExpanded,
/**
     * GS1 DataBarLimited 1D barcode symbology.
     */
    SDCSymbologyGS1DatabarLimited,
/**
     * PDF417 barcode symbology.
     */
    SDCSymbologyPDF417 NS_SWIFT_NAME(pdf417),
/**
     * MicroPDF417 barcode symbology.
     */
    SDCSymbologyMicroPDF417,
/**
     * MicroQR Code 2D barcode symbology.
     */
    SDCSymbologyMicroQR,
/**
     * Code32 1D barcode symbology.
     */
    SDCSymbologyCode32,
/**
     * Posi LAPA Reed Solomon 4-state code postal code symbology.
     */
    SDCSymbologyLapa4SC
} NS_SWIFT_NAME(Symbology);

/**
 * Get string representation for the provided symbology enum.
 */
SDC_EXTERN NSString *_Nonnull SDCSymbologyToString(SDCSymbology symbology) NS_SWIFT_NAME(getter:SDCSymbology.description(self:));

/**
 * Returns the list of all supported symbologies by the Scandit Data Capture SDK.
 */
SDC_EXTERN NSArray<NSNumber *> *_Nonnull SDCAllSymbologies(void);
