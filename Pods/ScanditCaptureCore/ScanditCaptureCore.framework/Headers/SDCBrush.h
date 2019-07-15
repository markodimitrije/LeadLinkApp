/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2017- Scandit AG. All rights reserved.
 */

#import <UIKit/UIView.h>

#import <ScanditCaptureCore/SDCBase.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Brushes define how objects are drawn on screen and allow to change their fill and stroke color as well as the stroke width. They are, for example, used to change the styling of barcode locations, or other objects drawn on top of the video preview. Brushes are immutable. Once created none of the members can be modified.
 */
NS_SWIFT_NAME(Brush)
SDC_EXPORTED_SYMBOL
@interface SDCBrush : NSObject

/**
 * Create a new default brush. Both fill and stroke color are set to fully transparent black. The stroke width is set to zero.
 */
- (instancetype)init;

/**
 * Create a new brush with provided fill, stroke colors and stroke width.
 */
- (instancetype)initWithFillColor:(nonnull UIColor *)fillColor
                      strokeColor:(nonnull UIColor *)strokeColor
                      strokeWidth:(CGFloat)strokeWidth NS_DESIGNATED_INITIALIZER;

/**
 * The fill color used to draw the object.
 */
@property (nonatomic, nonnull, readonly) UIColor *fillColor;
/**
 * The stroke color used to draw the object.
 */
@property (nonatomic, nonnull, readonly) UIColor *strokeColor;
/**
 * The width in device-independent pixels used to render the stroke.
 */
@property (nonatomic, readonly) CGFloat strokeWidth;

@end

NS_ASSUME_NONNULL_END
