/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2017- Scandit AG. All rights reserved.
 */

#include <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SDCDataCaptureContext;
@protocol SDCFrameData;

/**
 * SDCDataCaptureMode is the protocol implemented by all data capture modes, such as barcode capture, BarcodeTracking, or label capture. Capture modes are restricted to the set of data captures modes provided by the Scandit Data Capture SDK and is not available for implementing custom data capture modes.
 *
 * Capture modes need to be associated with a data capture context after they have been created using SDCDataCaptureContext.addMode:. This is done automatically when using any of the factory methods defined on barcode capture, BarcodeTracking (barcodeCaptureWithContext:settings:, barcodeTrackingWithContext:settings:). Manual addition is required when implementing your own custom data capture mode. Modes can be removed again using SDCDataCaptureContext.removeMode:.
 *
 * Multiple data capture modes can be associated with the same context. However, there are restrictions on which data capture modes can be used together. These restrictions are expressed in terms of capabilities that the capture modes require, .e.g. barcode scanning, tracking. No two capture modes that require the same capabilities can be used with the same data capture context. When conflicting requirements are detected, the data capture context will not process any frames and report an error.
 *
 * Usage Sample
 *
 * Because the SDCDataCaptureMode can not be instantiated directly, the example below uses the SDCBarcodeCapture to illustrate a typical usage of capture modes. Other capture modes will work very similarly. The typical steps are:
 *
 *   1. Configure the capture mode by first creating settings.
 *
 *   2. Instantiate the capture mode and associate with the context and the settings.
 *
 *   3. Registering a mode-specific listener (not shown).
 *
 *
 *
 *   4. Enabling recognition by setting the enabled property to YES.
 *
 * @code
 * let settings = BarcodeCaptureSettings()
 * settings.set(symbology: .qr, enabled: true)
 * let barcodeCapture = BarcodeCapture(context: context, settings: settings)
 * // Capture modes are enabled by default. The next line is not strictly necessary.
 * barcodeCapture.isEnabled = true
 * @endcode
 */
NS_SWIFT_NAME(DataCaptureMode)
@protocol SDCDataCaptureMode <NSObject>

/**
 * YES if this data capture mode is enabled, NO if not. Only enabled capture modes are processing frames.
 *
 * Changing this property from NO to YES causes this data capture mode to process frames.
 *
 * Changing this property from YES to NO causes this data capture mode to stop processing frames. The effect is immediate: no more frames will be processed after the change. However, if a frame is currently being processed, this frame will be completely processed and deliver any results/callbacks to the registered listeners. When changing this property from one of the listener callbacks that is called as a result of processing the frame, no more frames will be processed after that.
 *
 * Note that this property only affects recognition and does not affect the SDCFrameSource’s state.
 *
 * By default, this property is YES.
 */
@property (nonatomic, assign, getter=isEnabled) BOOL enabled NS_SWIFT_NAME(isEnabled);

/**
 * The context this data capture mode is attached to. When the data capture mode is currently not attached to a context, nil is returned.
 */
@property (nonatomic, nullable, readonly) SDCDataCaptureContext *context;

@end

NS_ASSUME_NONNULL_END
