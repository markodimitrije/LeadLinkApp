/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2017- Scandit AG. All rights reserved.
 */

#import <CoreGraphics/CoreGraphics.h>

/**
 * Polygon represented by 4 corners.
 */
struct SDCQuadrilateral {
    CGPoint topLeft;
    CGPoint topRight;
    CGPoint bottomRight;
    CGPoint bottomLeft;
} NS_SWIFT_NAME(Quadrilateral);
typedef struct __attribute__((objc_boxable)) SDCQuadrilateral SDCQuadrilateral;
