/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2017- Scandit AG. All rights reserved.
 */

#import <Foundation/Foundation.h>

#import <ScanditCaptureCore/SDCBase.h>
#import <ScanditBarcodeCapture/SDCSymbology.h>

SDC_EXTERN NSString *_Nonnull const SDCBarcodeTrackingSettingsErrorDomain
    NS_SWIFT_NAME(BarcodeTrackingSettingsErrorDomain);

@class SDCSymbologySettings;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(BarcodeTrackingSettings)
SDC_EXPORTED_SYMBOL
@interface SDCBarcodeTrackingSettings : NSObject <NSCopying>

/**
 * Returns the set of enabled symbologies.
 */
@property (nonatomic, nonnull, readonly)
    NSSet<NSNumber *> *enabledSymbologies NS_SWIFT_NAME(enabledSymbologyValues);

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/**
 * Create a new barcode tracking settings instance. All symbologies are disabled. Make sure to enable the symbologies required by your app before applying the settings to SDCBarcodeTracking with :meth:`~BarcodeTracking.ApplySettingsAsync.
 */
+ (instancetype)settings;

/**
 * The returned SDCSymbologySettings object contains symbology-specific settings.
 */
- (nullable SDCSymbologySettings *)settingsForSymbology:(SDCSymbology)symbology;

/**
 * Set property to the provided value. Use this method to set properties that are not yet part of a stable API. Properties set through this method may or may not be used or change in a future release.
 */
- (void)setValue:(id)value forProperty:(NSString *)property NS_SWIFT_NAME(set(value:forProperty:));

/**
 * Retrieve value of a previously set property. In case the property does not exist, nil is returned.
 */
- (nullable id)valueForProperty:(NSString *)property;

/**
 * This function provides a convenient shortcut to enabling decoding of particular symbologies without having to go through SDCSymbologySettings.
 * By default, all symbologies are turned off and symbologies need to be explicitly enabled.
 */
- (void)enableSymbologies:(nonnull NSSet<NSNumber *> *)symbologies;

/**
 * This function provides a convenient shortcut to enabling/disabling decoding of a particular symbology without having to go through SDCSymbologySettings.
 * .. note:
 *
 * @code
 * Some 1d barcode symbologies allow you to encode variable-length data. By default, the |sdk| only scans barcodes in a certain length range.
 *
 * If your application requires scanning of one of these symbologies, and the length is falling outside the default range, you may need to adjust the :prop:`active symbol counts<barcode.SymbologySettings.ActiveSymbolCounts>` for the symbology in addition to enabling it.
 * @endcode
 */
- (void)setSymbology:(SDCSymbology)symbology
             enabled:(BOOL)enabled NS_SWIFT_NAME(set(symbology:enabled:));

@end

NS_ASSUME_NONNULL_END
