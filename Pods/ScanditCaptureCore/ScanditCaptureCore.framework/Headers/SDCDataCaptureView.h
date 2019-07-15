/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2017- Scandit AG. All rights reserved.
 */

#import <UIKit/UIView.h>
#import <UIKit/UIApplication.h>
#import <ScanditCaptureCore/SDCBase.h>
#import <ScanditCaptureCore/SDCMeasureUnit.h>
#import <ScanditCaptureCore/SDCQuadrilateral.h>
#import <ScanditCaptureCore/SDCAnchor.h>
#import <ScanditCaptureCore/SDCControl.h>

NS_ASSUME_NONNULL_BEGIN

@class SDCDataCaptureView;
@class SDCDataCaptureContext;
@protocol SDCDataCaptureOverlay;

/**
 * Listener for observing the data capture view. This listener is typically used when you want to react to orientation and size changes, e.g. to adjust view finder and scan area parameters.
 */
NS_SWIFT_NAME(DataCaptureViewListener)
@protocol SDCDataCaptureViewListener <NSObject>

/**
 * Invoked when the data capture view changes size or orientation.
 */
- (void)dataCaptureView:(SDCDataCaptureView *)view
          didChangeSize:(CGSize)size
            orientation:(UIInterfaceOrientation)orientation;

@end

/**
 * The capture view is the main UI view to be used together with the data capture context for applications that wish to display a video preview together with additional augmentations such as barcode locations.
 *
 * The data capture view itself only displays the preview and shows UI elements to control the camera, such as buttons to switch torch on and off, or a button to switch between front and back facing cameras. Augmentations, such as the locations of identified barcodes are provided by individual overlays.
 *
 * Unless otherwise specified, methods and properties of this class should only be accessed from the main thread.
 *
 * @remark Targeting iOS 10 and earlier
 *
 * On devices running iOS 10 and earlier, the data capture view should be constrained to be under the top layout guide and above the bottom layout guide to avoid certain parts of the view not being shown properly.
 *
 * On devices running iOS 11 and later, constraining to be inside the safe area is not necessary for the view to be shown properly and will automatically respect safe area guides.
 *
 * Related topics: Get Started With Barcode Scanning, Get Started With MatrixScan, Core Concepts of the Scandit Data Capture SDK, Choose the Right Scanner UI for Your Use Case.
 */
NS_SWIFT_NAME(DataCaptureView)
SDC_EXPORTED_SYMBOL
@interface SDCDataCaptureView : UIView

/**
 * The data capture context of this capture view. This property must be set to an instance of the data capture context for this view to display anything.
 *
 * When the capture context is attached to a data capture view, it is removed from any other data capture view it was attached to.
 */
@property (nonatomic, strong, nullable) SDCDataCaptureContext *context;
/**
 * The point of interest of this data capture view. By default, the point of interest is centered in the data capture view.
 * The point of interest is used to control the center of attention for a couple of different subsystems:
 *
 *   • It is used to define where auto focus and exposure metering of the camera  will happen.
 *
 *   • barcode capture: When code selection is enabled, the point of interest defines the point at which codes are selected. When code selection is disabled, the point of interest the defines the point at which the codes will most likely be visible. Recognition is optimized to scan codes at this location.
 *
 *   • It affects the location of rendered viewfinders.
 */
@property (nonatomic, assign) SDCPointWithUnit pointOfInterest;
/**
 * The margins to use for the scan area. The margins are measured from the border of the data capture view and allow to specify a region around the border that is excluded from scanning.
 *
 * By default, the margins are zero and the scanning happens in the visible part of the preview.
 */
@property (nonatomic, assign) SDCMarginsWithUnit scanAreaMargins;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/**
 * Initialize a new data capture view. The context must be provided by setting the context property.
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**
 * Initialize a new data capture view. When a data capture context is provided, the view is associated with the context. The data capture context can be changed at a later point by setting the context property.
 */
+ (instancetype)dataCaptureViewForContext:(nullable SDCDataCaptureContext *)context
                                    frame:(CGRect)frame;

- (instancetype)initWithCoder:(NSCoder *)decoder NS_UNAVAILABLE;

/**
 * Add overlay to this data capture view. If the overlay is already part of this view, the call has no effect. It is only allowed to call this method during setup: once the recognition process is running, calling this method will result in an error.
 */
- (void)addOverlay:(nonnull id<SDCDataCaptureOverlay>)overlay NS_SWIFT_NAME(addOverlay(_:));
/**
 * Remove overlay from this data capture view. If the overlay is not part of this view, the calls has no effect. It is only allowed to call this method during setup: once the recognition process is running, calling this method will result in an error.
 */
- (void)removeOverlay:(nonnull id<SDCDataCaptureOverlay>)overlay NS_SWIFT_NAME(removeOverlay(_:));

/**
 * Add listener to the data capture view.
 *
 * In case the same listener is already observing this instance, calling this method will not add the listener again. Once the listener is no longer required, make sure to remove it again. The listener is stored using a weak reference and must thus be retained by the caller for it to not go out of scope.
 */
- (void)addListener:(nonnull id<SDCDataCaptureViewListener>)listener NS_SWIFT_NAME(addListener(_:));
/**
 * Remove listener from the data capture view.
 *
 * Remove a previously registered listener. In case the listener is not currently observing this instance, calling this method has no effect.
 */
- (void)removeListener:(nonnull id<SDCDataCaptureViewListener>)listener
    NS_SWIFT_NAME(removeListener(_:));

/**
 * Add control to the data capture view. In case multiple controls get added, the order in which addControl: gets called determines how the controls are going to be layed out.
 *
 * The controls are placed in linear layout at the top of the screen with the controls displayed from left to right.
 *
 * @remark At the moment, the only supported control is the SDCTorchSwitchControl
 */
- (void)addControl:(nonnull id<SDCControl>)control NS_SWIFT_NAME(addControl(_:));
/**
 * Remove previously added control from data capture view.
 */
- (void)removeControl:(nonnull id<SDCControl>)control NS_SWIFT_NAME(removeControl(_:));

/**
 * Converts a point in the coordinate system of the last visible frame and maps it to a coordinate in the view.
 *
 * This method is thread-safe and can be called from any thread.
 */
- (CGPoint)viewPointForFramePoint:(CGPoint)point;
/**
 * Converts a quadrilateral in the coordinate system of the last visible frame and maps it to a coordinate in the view.
 */
- (SDCQuadrilateral)viewQuadrilateralForFrameQuadrilateral:(SDCQuadrilateral)quadrilateral;

/**
 * The anchor point to use for positioning the logo. By default the logo is placed in the lower-right corner of the scan area (SDCAnchorBottomRight).
 *
 * To shift the logo relative to the anchor position, use the logoOffset property.
 *
 * This property has no effect when the logo is drawn by one of the viewfinders.
 */
@property (nonatomic, assign) SDCAnchor logoAnchor;

/**
 * The offset relative to the logo anchor. When specified in pixels (SDCMeasureUnitPixel) or device-independent pixels (SDCMeasureUnitDIP), the offset is used as-is. When specified as a fraction (SDCMeasureUnitFraction), the offset is computed relative to the view size minus the scan area margins. For example, a value of 0.1 for the x-coordinate will set the offset to be 10% of the view width minus the left and right margins.
 *
 * This property has no effect when the logo is drawn by one of the viewfinders.
 */
@property (nonatomic, assign) SDCPointWithUnit logoOffset;
@end

NS_ASSUME_NONNULL_END
