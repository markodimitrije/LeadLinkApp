/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2017- Scandit AG. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <ScanditCaptureCore/SDCDataCaptureMode.h>
#import <ScanditCaptureCore/SDCBase.h>
@class SDCBarcodeCapture;
@class SDCBarcodeCaptureSession;
@class SDCBarcodeCaptureSettings;
@class SDCDataCaptureContext;
@class SDCBarcodeCaptureFeedback;
@protocol SDCFrameData;

NS_ASSUME_NONNULL_BEGIN

/**
 * Delegate protocol for traditional barcode capture.
 */
NS_SWIFT_NAME(BarcodeCaptureListener)
@protocol SDCBarcodeCaptureListener <NSObject>

@required

/**
 * Invoked whenever a code has been scanned. The newly scanned codes can be retrieved from SDCBarcodeCaptureSession.newlyRecognizedBarcodes.
 *
 * This method is invoked from a recognition internal thread. To perform UI work, you must dispatch to the main thread first.
 *
 * Inside this method, you will typically want to start processing the scanned barcodes somehow, e.g. by using the data to look up information in a database, or to open an URL encoded in the barcode data. Depending on the application, you will want to pause, or stop recognition, or continue reading barcodes:
 *
 *   • To pause scanning, but keep the camera (frame source) running, just set the barcode capture’s enabled property to NO.
 *
 * captureMode.isEnabled = true
 *
 *   • To stop scanning, you will need to both disable the capture mode and stop the frame source. While it’s possible to only stop the camera and keep the capture mode enabled, this may lead to additional scan events being delivered, which is typically not desired. The following lines of code show how to disable the capture mode and stop the frame source as well:
 *
 * // no more didScan callbacks will be invoked after this call.
 * captureMode.isEnabled = false
 * // asynchronously turn off the camera as quickly as possible.
 * captureMode.context?.frameSource?.switch(toDesiredState: .off, completionHandler: nil)
 *
 * @code
 * captureMode.isEnabled = true
 * @endcode
 *
 * @code
 * // no more didScan callbacks will be invoked after this call.
 * captureMode.isEnabled = false
 * // asynchronously turn off the camera as quickly as possible.
 * captureMode.context?.frameSource?.switch(toDesiredState: .off, completionHandler: nil)
 * @endcode
 */
- (void)barcodeCapture:(SDCBarcodeCapture *)barcodeCapture
      didScanInSession:(SDCBarcodeCaptureSession *)session
             frameData:(id<SDCFrameData>)frameData;

@optional

/**
 * Invoked after a frame has been processed by barcode capture and the session has been updated. In contrast to barcodeCapture:didScanInSession:frameData:, this method is invoked, regardless whether a code was scanned or not. If codes were recognized in this frame, this method is invoked after barcodeCapture:didScanInSession:frameData:.
 *
 * This method is invoked from a recognition internal thread. To perform UI work, you must dispatch to the main thread first. Further recognition is blocked until this method completes. It is thus recommended to do as little work as possible in this method.
 *
 * See the documentation in barcodeCapture:didScanInSession:frameData: for information on how to properly stop recognition of barcodes.
 */
- (void)barcodeCapture:(SDCBarcodeCapture *)barcodeCapture
      didUpdateSession:(SDCBarcodeCaptureSession *)session
             frameData:(id<SDCFrameData>)frameData;

/**
 * Called when the listener starts observing the barcode capture instance.
 */
- (void)didStartObservingBarcodeCapture:(SDCBarcodeCapture *)barcodeCapture;

/**
 * Called when the listener stops observing the barcode capture instance.
 */
- (void)didStopObservingBarcodeCapture:(SDCBarcodeCapture *)barcodeCapture;

@end

/**
 * Capture mode for single barcode scanning. For MatrixScan-based barcode capture, use SDCBarcodeTracking instead.
 *
 * Learn more on how to use barcode capture in our Get Started With Barcode Scanning guide.
 *
 * This capture mode uses the barcode scanning capability. It can not be used together with other capture modes that require the same capabilities, e.g. SDCBarcodeTracking or SDCLabelCapture.
 */
NS_SWIFT_NAME(BarcodeCapture)
SDC_EXPORTED_SYMBOL
@interface SDCBarcodeCapture : NSObject <SDCDataCaptureMode>

/**
 * Instance of SDCBarcodeCaptureFeedback that is used by the barcode scanner to notify users about Success and Failure events.
 *
 * The default instance of the Feedback will have both sound and vibration enabled. A default beep sound will be used for the sound.
 *
 * To change the feedback emitted, the SDCBarcodeCaptureFeedback can be modified as shown below, or a new one can be assigned.
 *
 * @code
 * let barcodeCapture: BarcodeCapture = ...
 * barcodeCapture.feedback.success = Feedback(vibration: nil, sound: Sound.default)
 * @endcode
 */
@property (nonatomic, strong, nonnull) SDCBarcodeCaptureFeedback *feedback;
/**
 * Implemented from SDCDataCaptureMode. See SDCDataCaptureMode.context.
 */
@property (nonatomic, nullable, readonly) SDCDataCaptureContext *context;
/**
 * Implemented from SDCDataCaptureMode. See SDCDataCaptureMode.enabled.
 */
@property (nonatomic, assign, getter=isEnabled) BOOL enabled;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/**
 * Construct a new barcode capture mode with the provided context and settings. The capture mode is automatically added to the context.
 */
+ (instancetype)barcodeCaptureWithContext:(nonnull SDCDataCaptureContext *)context
                                 settings:(nonnull SDCBarcodeCaptureSettings *)settings
    NS_SWIFT_NAME(init(context:settings:));

/**
 * Construct a new barcode capture mode with the provided JSON serialization. See Serialization for details. The capture mode is automatically added to the context.
 */
+ (nullable instancetype)barcodeCaptureFromJSONString:(nonnull NSString *)jsonString
                                              context:(nonnull SDCDataCaptureContext *)context
                                                error:(NSError *_Nullable *_Nullable)error
    NS_SWIFT_NAME(init(jsonString:context:));

/**
 * Asynchronously apply the new settings to the barcode scanner. If the scanner is currently running, the task will complete when the next frame is processed, and will use the new settings for that frame. If the scanner is currently not running, the task will complete as soon as the settings have been stored and won’t wait until the next frame is going to be processed.
 */
- (void)applySettings:(nonnull SDCBarcodeCaptureSettings *)settings
    completionHandler:(nullable void (^)(void))completionHandler;

/**
 * Add listener to observe this barcode capture instance.
 *
 * In case the same listener is already observing this instance, calling this method will not add the listener again. Once the listener is no longer required, make sure to remove it again. The listener is stored using a weak reference and must thus be retained by the caller for it to not go out of scope.
 */
- (void)addListener:(nullable id<SDCBarcodeCaptureListener>)listener NS_SWIFT_NAME(addListener(_:));

/**
 * Remove listener from this barcode capture instance.
 *
 * Remove a previously registered listener. In case the listener is not currently observing this instance, calling this method has no effect.
 */
- (void)removeListener:(nullable id<SDCBarcodeCaptureListener>)listener
    NS_SWIFT_NAME(removeListener(_:));

/**
 * Updates the mode according to a JSON serialization. See Serialization for details.
 */
- (BOOL)updateFromJSONString:(nonnull NSString *)jsonString
                       error:(NSError *_Nullable *_Nullable)error;

@end

NS_ASSUME_NONNULL_END
