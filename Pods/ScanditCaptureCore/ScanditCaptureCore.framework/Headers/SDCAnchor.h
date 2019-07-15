/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2017- Scandit AG. All rights reserved.
 */

#import <Foundation/Foundation.h>

/**
 * An enumeration of possible anchoring points in a geometric object such as CGRect or quadrilaterals. Values of this enumeration are typically used to determine where elements are placed on the screen. For example, it is used to place the logo on screen.
 */
NS_SWIFT_NAME(Anchor)
typedef NS_CLOSED_ENUM(NSUInteger, SDCAnchor) {
/**
     * This value will use the top left corner as the anchor point.
     */
    SDCAnchorTopLeft,
/**
     * This value will will use the center of the top edge as the anchor point.
     */
    SDCAnchorTopCenter,
/**
     * This value will use the top right corner as the anchor point.
     */
    SDCAnchorTopRight,
/**
     * This value will use the center left corner as the anchor point.
     */
    SDCAnchorCenterLeft,
/**
     * This value will use the center as the anchor point.
     */
    SDCAnchorCenter,
/**
     * This value will use the center of the right edge as the anchor point.
     */
    SDCAnchorCenterRight,
/**
     * This value will use the bottom left corner as the anchor point.
     */
    SDCAnchorBottomLeft,
/**
     * This value will use the center of the bottom edge as the anchor point.
     */
    SDCAnchorBottomCenter,
/**
     * This value will use the bottom right corner as the anchor point.
     */
    SDCAnchorBottomRight,
} NS_SWIFT_NAME(Anchor);

