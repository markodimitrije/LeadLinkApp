/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2017- Scandit AG. All rights reserved.
 */

#import <Foundation/Foundation.h>

/**
 * Enumeration for different directions.
 */
typedef NS_CLOSED_ENUM(NSUInteger, SDCDirection) {
/**
     * Direction left to right.
     */
    SDCDirectionLeftToRight,
/**
     * Direction right to left.
     */
    SDCDirectionRightToLeft,
/**
     * Direction horizontal.
     */
    SDCDirectionHorizontal,
/**
     * Direction top to bottom.
     */
    SDCDirectionTopToBottom,
/**
     * Direction bottom to top.
     */
    SDCDirectionBottomToTop,
/**
     * Direction vertical.
     */
    SDCDirectionVertical,
/**
     * No direction.
     */
    SDCDirectionNone
} NS_SWIFT_NAME(Direction);

