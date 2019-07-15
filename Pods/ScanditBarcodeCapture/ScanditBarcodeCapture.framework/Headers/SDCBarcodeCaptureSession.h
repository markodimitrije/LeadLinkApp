/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2017- Scandit AG. All rights reserved.
 */

#import <Foundation/Foundation.h>

#import <ScanditCaptureCore/SDCBase.h>

@class SDCBarcode;
@class SDCLocalizedOnlyBarcode;

NS_ASSUME_NONNULL_BEGIN

/**
 * The scan session is responsible for determining the list of relevant barcodes by filtering out duplicates. This filtering of duplicates is completely time-based and doesn’t use any information about the location of the barcode. For location-based tracking over multiple frames, you may be better off using SDCBarcodeTracking. By default, all the codes scanned in a frame are always reported. It is possible to filter out codes recently scanned by changing SDCBarcodeCaptureSettings.codeDuplicateFilter.
 *
 * When the barcode capture mode is disabled, the session’s duplicate filter is reset.
 *
 * The scan session should only be accessed from within the callbacks to which it is provided as an argument. It is not safe to be accessed from anywhere else since it may be concurrently modified. However, the barcodes returned by the session can be used outside the callbacks.
 */
NS_SWIFT_NAME(BarcodeCaptureSession)
SDC_EXPORTED_SYMBOL
@interface SDCBarcodeCaptureSession : NSObject

/**
 * List of codes that were newly recognized in the last processed frame.
 */
@property (nonatomic, nonnull, readonly) NSArray<SDCBarcode *> *newlyRecognizedBarcodes;
/**
 * List of codes that were newly localized (but not recognized) in the last processed frame.
 */
@property (nonatomic, nonnull, readonly) NSArray<SDCLocalizedOnlyBarcode *> *newlyLocalizedBarcodes;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/**
 * Reset the barcode scanner session, effectively clearing the history of scanned codes. This affects duplicate filtering: when calling reset every frame this has the same effect as setting the SDCBarcodeCaptureSettings.codeDuplicateFilter to 0.
 */
- (void)reset;

@end

NS_ASSUME_NONNULL_END
