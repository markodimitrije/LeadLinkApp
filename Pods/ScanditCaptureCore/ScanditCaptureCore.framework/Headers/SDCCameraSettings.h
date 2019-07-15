/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2017- Scandit AG. All rights reserved.
 */

#include <Foundation/Foundation.h>
#include <CoreGraphics/CoreGraphics.h>
#import <ScanditCaptureCore/SDCBase.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_CLOSED_ENUM(NSUInteger, SDCVideoResolution) {
/**
     * Resolution is 1280x720
     */
    SDCVideoResolutionHD NS_SWIFT_NAME(hd) = 0,
/**
     * Resolution is 1920x1080
     */
    SDCVideoResolutionFullHD = 1,
/**
     * The highest available video resolution on the device. Use with caution, as this video resolution can slow down processing substantially.
     */
    SDCVideoResolutionHighest = 2,
/**
     * In contrast to SDCVideoResolutionFullHD, and SDCVideoResolutionHD, SDCVideoResolutionAuto will select the resolution based on hardware capabilities and/or scan-performance considerations. The chosen resolution may change in future versions of the software.
     */
    SDCVideoResolutionAuto = 3,
/**
     * Resolution is 3840x2160
     */
    SDCVideoResolutionUHD4K NS_SWIFT_NAME(uhd4k) = 4,
} NS_SWIFT_NAME(VideoResolution);

/**
 * Enumeration of possible focus ranges to use. This can be used to restrict the auto-focus system to only consider objects in a certain range to focus on.
 */
typedef NS_CLOSED_ENUM(NSUInteger, SDCFocusRange) {
/**
     * Use the full focus range supported by the camera.
     */
    SDCFocusRangeFull,
/**
     * Only focus on objects that are far from the camera.
     */
    SDCFocusRangeFar,
/**
     * Only focus on objects that are near to the camera.
     */
    SDCFocusRangeNear,
} NS_SWIFT_NAME(FocusRange);

SDC_EXTERN const CGFloat SDCCurrentZoomFactor NS_SWIFT_NAME(CurrentZoomFactor);

/**
 * Holds camera-specific settings such as preferred resolution, maximum frame rate etc. The defaults are chosen such that they work for a wide variety of use-cases. You may apply custom settings to further optimize scan performance for your particular use-case. There is typically no need to customize the camera settings beyond changing the preferred resolution.
 *
 * Holds camera related settings such as preview resolution and maximum frame rate to use.
 */
NS_SWIFT_NAME(CameraSettings)
SDC_EXPORTED_SYMBOL
@interface SDCCameraSettings : NSObject

/**
 * Create new default camera settings. maxFrameRate is set to 30, zoomFactor is set to 1 and preferredResolution is set to SDCVideoResolutionAuto.
 */
- (instancetype)init;
/**
 * Create a copy of the provided settings.
 */
- (instancetype)initWithSettings:(nonnull SDCCameraSettings *)settings;

/**
 * The preferred resolution to use for the camera. The camera will use the resolution that is closests to the resolution preference. For example, if only lower resolutions than the preferred resolution are available, the highest available resolution will be used.
 *
 * The default value is SDCVideoResolutionAuto.
 */
@property (nonatomic, assign) SDCVideoResolution preferredResolution;
/**
 * The maximum frame rate to use for the camera. The actual maximum framerate will be the mimumum of the maximally available frame rate of the camera and the provided value.
 *
 * The default max frame rate is 30 Hz.
 */
@property (nonatomic, assign) CGFloat maxFrameRate;
/**
 * The zoom factor to use for the camera. This value is a multiplier, a value of 1.0 means no zoom, while a value of 2.0 doubles the size of the image, but halves the field of view.
 *
 * Values less than 1.0 are treated as 1.0. Values greater than the maximum available zoom factor are clamped to the maximum accepted value.
 *
 * If the zoom factor should not change, CurrentZoomFactor should be used.
 *
 * The default zoom factor is 1.0.
 */
@property (nonatomic, assign) CGFloat zoomFactor;
/**
 * The focus range to primarily use, if supported by the device.
 */
@property (nonatomic, assign) SDCFocusRange focusRange;

@end

NS_ASSUME_NONNULL_END
