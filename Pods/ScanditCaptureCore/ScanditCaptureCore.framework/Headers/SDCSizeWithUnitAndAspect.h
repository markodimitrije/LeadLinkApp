/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2017- Scandit AG. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <ScanditCaptureCore/SDCMeasureUnit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Holds a SDCSizingMode - and corresponding required values - to define a rectangular size.
 */
NS_SWIFT_NAME(SizeWithUnitAndAspect)
@interface SDCSizeWithUnitAndAspect : NSObject

/**
 * The values for width and height.
 *
 * @remark This value will always be SDCSizeWithUnitZero unless sizingMode is SDCSizingModeWidthAndHeight.
 */
@property (nonatomic, readonly) SDCSizeWithUnit widthAndHeight;
/**
 * The value for width and the aspect ratio for height.
 *
 * @remark This value will always be SDCSizeWithAspectZero unless sizingMode is SDCSizingModeWidthAndAspectRatio.
 */
@property (nonatomic, readonly) SDCSizeWithAspect widthAndAspectRatio;
/**
 * The value for height and the aspect ratio for width.
 *
 * @remark This value will always be SDCSizeWithAspectZero unless sizingMode is SDCSizingModeHeightAndAspectRatio.
 */
@property (nonatomic, readonly) SDCSizeWithAspect heightAndAspectRatio;
/**
 * The sizing mode.
 */
@property (nonatomic, readonly) SDCSizingMode sizingMode;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
