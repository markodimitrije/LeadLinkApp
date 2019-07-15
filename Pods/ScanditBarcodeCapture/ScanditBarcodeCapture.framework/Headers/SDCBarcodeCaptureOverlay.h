/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2017- Scandit AG. All rights reserved.
 */

#import <Foundation/Foundation.h>

#import <ScanditCaptureCore/SDCBase.h>
#import <ScanditCaptureCore/SDCDataCaptureOverlay.h>

NS_ASSUME_NONNULL_BEGIN

@class SDCBarcodeCapture;
@class SDCBrush;
@class SDCDataCaptureView;
@protocol SDCViewfinder;

/**
 * Overlay for the SDCBarcodeCapture capture mode that displays recognized barcodes on top of the video preview. The appearance of the visualized barcodes can be configured or turned off completely through the brush property.
 */
NS_SWIFT_NAME(BarcodeCaptureOverlay)
SDC_EXPORTED_SYMBOL
@interface SDCBarcodeCaptureOverlay : NSObject <SDCDataCaptureOverlay>

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/**
 * Construct a new barcode capture overlay for the provided barcode capture instance. For the overlay to be displayed on screen, it must be added to a SDCDataCaptureView.
 */
+ (instancetype)overlayWithBarcodeCapture:(nonnull SDCBarcodeCapture *)barcodeCapture;
/**
 * Construct a new barcode capture overlay for the provided barcode capture instance. When passing a non-nil view instance, the overlay is automatically added to the view.
 */
+ (instancetype)overlayWithBarcodeCapture:(nonnull SDCBarcodeCapture *)barcodeCapture
                       forDataCaptureView:(nullable SDCDataCaptureView *)view;

/**
 * Construct a new barcode capture overlay with the provided JSON serialization. See Serialization for details. The overlay is automatically added to the capture mode.
 */
+ (nullable instancetype)barcodeCaptureOverlayFromJSONString:(nonnull NSString *)jsonString
                                                        mode:(nonnull SDCBarcodeCapture *)mode
                                                       error:(NSError **)error
    NS_SWIFT_NAME(init(jsonString:barcodeCapture:));

/**
 * Updates the overlay according to a JSON serialization. See Serialization for details.
 */
- (BOOL)updateFromJSONString:(nonnull NSString *)jsonString error:(NSError **)error;

/**
 * The brush used for visualizing a recognized barcode in the UI. To turn off drawing of locations, set the brush to use both a transparent fill and stroke color. By default, the color is set to a semi-transparent “Scandit” and a stroke width of 1.
 */
@property (nonatomic, strong, nonnull) SDCBrush *brush;

/**
 * Whether to show scan area guides on top of the preview. This property is useful during development to visualize the current scan areas on screen. It is not meant to be used for production. By default this property is NO.
 */
@property (nonatomic, assign) BOOL shouldShowScanAreaGuides;

/**
 * Set the viewfinder. By default, the viewfinder is nil. Set this to an instance of SDCRectangularViewfinder or SDCLaserlineViewfinder if you want to draw a viewfinder.
 */
@property (nonatomic, strong, nullable) id<SDCViewfinder> viewfinder;

@end

NS_ASSUME_NONNULL_END
