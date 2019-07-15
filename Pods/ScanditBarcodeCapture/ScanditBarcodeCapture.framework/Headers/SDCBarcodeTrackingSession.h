/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2017- Scandit AG. All rights reserved.
 */

#import <Foundation/Foundation.h>

#import <ScanditCaptureCore/SDCBase.h>

@class SDCTrackedBarcode;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(BarcodeTrackingSession)
SDC_EXPORTED_SYMBOL
@interface SDCBarcodeTrackingSession : NSObject

/**
 * Newly tracked barcodes.
 */
@property (nonatomic, nonnull, readonly) NSArray<SDCTrackedBarcode *> *addedTrackedBarcodes;
/**
 * Lost tracked barcodes.
 */
@property (nonatomic, nonnull, readonly) NSArray<NSNumber *> *removedTrackedBarcodes;
/**
 * Updated tracked barcodes (new location).
 */
@property (nonatomic, nonnull, readonly) NSArray<SDCTrackedBarcode *> *updatedTrackedBarcodes;
/**
 * A map from identifiers to tracked barcodes. It contains all currently tracked barcodes.
 */
@property (nonatomic, strong, readonly)
    NSDictionary<NSNumber *, SDCTrackedBarcode *> *trackedBarcodes;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
