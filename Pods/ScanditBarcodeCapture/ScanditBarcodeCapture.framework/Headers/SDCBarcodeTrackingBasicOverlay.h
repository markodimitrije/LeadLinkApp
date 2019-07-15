/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2017- Scandit AG. All rights reserved.
 */

#import <Foundation/Foundation.h>

#import <ScanditCaptureCore/SDCBase.h>
#import <ScanditCaptureCore/SDCDataCaptureOverlay.h>

@class SDCBarcodeTracking;
@class SDCBrush;
@class SDCTrackedBarcode;
@class SDCBarcodeTrackingBasicOverlay;
@class SDCDataCaptureView;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(BarcodeTrackingBasicOverlayDelegate)
@protocol SDCBarcodeTrackingBasicOverlayDelegate <NSObject>

/**
 * Callback method that can be used to set a SDCBrush for a tracked barcode. It is called when a new tracked barcode appears. Called from the rendering thread.
 * If the callback returns nil, then no visualization will be drawn for the tracked barcode. Additionally, tapping on the barcode will have no effect - the action defined by barcodeTrackingBasicOverlay:didTapTrackedBarcode: callback will not be performed.
 */
- (nullable SDCBrush *)barcodeTrackingBasicOverlay:(nonnull SDCBarcodeTrackingBasicOverlay *)overlay
                            brushForTrackedBarcode:(nonnull SDCTrackedBarcode *)trackedBarcode;

/**
 * Callback method that can be used to define an action that should be performed once a tracked barcode is tapped. Called from the main thread.
 *
 * If you are adding a UIGestureRecognizer to the data capture view, ensure that the cancelsTouchesInView property is set to NO as otherwise tap gestures will be cancelled instead of successfully completing.
 */
- (void)barcodeTrackingBasicOverlay:(nonnull SDCBarcodeTrackingBasicOverlay *)overlay
               didTapTrackedBarcode:(nonnull SDCTrackedBarcode *)trackedBarcode;

@end

NS_SWIFT_NAME(BarcodeTrackingBasicOverlay)
SDC_EXPORTED_SYMBOL
@interface SDCBarcodeTrackingBasicOverlay : NSObject <SDCDataCaptureOverlay>

/**
 * The delegate which is called whenever a new TrackedBarcode is newly tracked or newly recognized.
 */
@property (nonatomic, weak, nullable) id<SDCBarcodeTrackingBasicOverlayDelegate> delegate;
/**
 * The default brush applied to recognized tracked barcodes. This is the brush used if SDCBarcodeTrackingBasicOverlayDelegate is not implemented.
 * Setting this brush to nil hides all tracked barcodes, unless setBrush:forTrackedBarcode: is called.
 */
@property (nonatomic, strong, nullable) SDCBrush *defaultBrush;

/**
 * When set to YES, this overlay will visualize the active scan area used for BarcodeTracking. This is useful to check margins defined on the SDCDataCaptureView are set correctly. This property is meant for debugging during development and is not intended for use in production.
 *
 * By default this property is NO.
 */
@property (nonatomic, assign) BOOL shouldShowScanAreaGuides;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/**
 * Construct a new barcode tracking basic overlay for the barcode tracking instance. For the overlay to be displayed on screen, it must be added to a SDCDataCaptureView.
 */
+ (instancetype)overlayWithBarcodeTracking:(nonnull SDCBarcodeTracking *)barcodeTracking;
/**
 * Construct a new barcode tracking basic overlay for the barcode tracking instance. The overlay is automatically added to the view.
 */
+ (instancetype)overlayWithBarcodeTracking:(nonnull SDCBarcodeTracking *)barcodeTracking
                        forDataCaptureView:(nullable SDCDataCaptureView *)view;

/**
 * Construct a new barcode tracking basic overlay with the provided JSON serialization. See Serialization for details. The overlay is automatically added to the capture mode.
 */
+ (nullable instancetype)barcodeTrackingBasicOverlayFromJSONString:(nonnull NSString *)jsonString
                                                              mode:
                                                                  (nonnull SDCBarcodeTracking *)mode
                                                             error:(NSError **)error
    NS_SWIFT_NAME(init(jsonString:barcodeCapture:));

/**
 * Updates the overlay according to a JSON serialization. See Serialization for details.
 */
- (BOOL)updateFromJSONString:(nonnull NSString *)jsonString error:(NSError **)error;

/**
 * The method can be called to change the visualization style of a tracked barcode. This method is thread-safe, it can be called from any thread.
 * If the brush is nil, then no visualization will be drawn for the tracked barcode. Additionally, tapping on the barcode will have no effect - the action defined by SDCBarcodeTrackingBasicOverlayDelegate.barcodeTrackingBasicOverlay:didTapTrackedBarcode: callback will not be performed.
 */
- (void)setBrush:(nullable SDCBrush *)brush
    forTrackedBarcode:(nonnull SDCTrackedBarcode *)trackedBarcode;

/**
 * Clear all currently displayed visualizations for the tracked barcodes.
 *
 * This only applies to the currently tracked barcodes, the visualizations for the new ones will still appear.
 */
- (void)clearTrackedBarcodeBrushes;

@end

NS_ASSUME_NONNULL_END
