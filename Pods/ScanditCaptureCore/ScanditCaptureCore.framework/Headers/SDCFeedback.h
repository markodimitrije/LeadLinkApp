/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2017- Scandit AG. All rights reserved.
 */

#import <Foundation/Foundation.h>

#import <ScanditCaptureCore/SDCBase.h>

@class SDCVibration;
@class SDCSound;

NS_ASSUME_NONNULL_BEGIN

/**
 * A feedback consisting of a sound and vibration, for example to be provided by a device when a code has been successfully scanned.
 */
NS_SWIFT_NAME(Feedback)
SDC_EXPORTED_SYMBOL
@interface SDCFeedback : NSObject

/**
 * The default feedback consisting of a default sound and a default vibration.
 */
@property (class, nonatomic, readonly) SDCFeedback *defaultFeedback;

/**
 * Created a new Feedback object with the given vibration and sound.
 */
- (instancetype)initWithVibration:(nullable SDCVibration *)vibration
                            sound:(nullable SDCSound *)sound;

/**
 * Whether to vibrate when a feedback is required. This property is further influenced by the device’s ring mode: the device may not vibrate even if this property is properly set to a non-nil instance.
 */
@property (nonatomic, nullable, readonly) SDCVibration *vibration;
/**
 * Whether to play a beep sound when a feedback is required. Depending on the device’s ring mode and/or volume settings, no sound may be played even if this property is properly set to a non-nil instance.
 */
@property (nonatomic, nullable, readonly) SDCSound *sound;

/**
 * Emit the feedback defined by this object. This method is further influenced by the device’s ring mode and/or volume settings - check sound and vibration for more details.
 */
- (void)emit;

@end

NS_ASSUME_NONNULL_END
