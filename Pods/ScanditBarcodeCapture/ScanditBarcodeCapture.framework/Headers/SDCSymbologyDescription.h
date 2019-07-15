/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2017- Scandit AG. All rights reserved.
 */

#import <Foundation/Foundation.h>

#import <ScanditCaptureCore/SDCBase.h>
#import <ScanditBarcodeCapture/SDCSymbology.h>

NS_ASSUME_NONNULL_BEGIN

struct SDCRange {
/**
     * Minimum of the range.
     */
    NSInteger minimum;
/**
     * Maximum of the range.
     */
    NSInteger maximum;
/**
     * Step of the range.
     */
    NSInteger step;
};
typedef struct __attribute__((objc_boxable)) SDCRange SDCRange;

/**
 * Check if a given range is valid.
 */
SDC_EXTERN BOOL SDCRangeIsValid(SDCRange range) NS_SWIFT_NAME(getter:SDCRange.isValid(self:));
/**
 * Check if a given range is fixed.
 */
SDC_EXTERN BOOL SDCRangeIsFixed(SDCRange range) NS_SWIFT_NAME(getter:SDCRange.isFixed(self:));

/**
 * Description specific to a particular barcode symbology.
 */
NS_SWIFT_NAME(SymbologyDescription)
SDC_EXPORTED_SYMBOL
@interface SDCSymbologyDescription : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/**
 * Get the symbology for a given identifier.
 */
+ (SDCSymbology)symbologyFromIdentifier:(nonnull NSString *)identifier;

/**
 * Creates a new symbology description for a given barcode symbology.
 */
- (instancetype)initWithSymbology:(SDCSymbology)symbology NS_DESIGNATED_INITIALIZER;

/**
 * Identifier of the symbology associated with this description.
 */
@property (nonatomic, nonnull, readonly) NSString *identifier;
/**
 * The human readable name of the symbology associated with this description.
 */
@property (nonatomic, nonnull, readonly) NSString *readableName;
/**
 * Determines whether the symbology associated with this description is available.
 */
@property (nonatomic, readonly) BOOL isAvailable;
/**
 * Determines whether decoding of color-inverted (bright on dark) codes for the symbology associated with this description is available.
 */
@property (nonatomic, readonly) BOOL isColorInvertible;
/**
 * The supported active symbol count range for the symbology associated with this description.
 */
@property (nonatomic, readonly) SDCRange activeSymbolCountRange;
/**
 * The default symbol count range for the symbology associated with this description.
 */
@property (nonatomic, readonly) SDCRange defaultSymbolCountRange;
/**
 * A list of extensions supported by the symbology associated with this description.
 */
@property (nonatomic, nonnull, readonly) NSSet<NSString *> *supportedExtensions;
/**
 * Get a description of each available barcode symbology.
 */
@property (class, nonatomic, nonnull, readonly)
    NSArray<SDCSymbologyDescription *> *allSymbologyDescriptions NS_SWIFT_NAME(all);

@end

NS_ASSUME_NONNULL_END
