/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2017- Scandit AG. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <ScanditCaptureCore/SDCBase.h>
NS_ASSUME_NONNULL_BEGIN

/**
 * Defines the encoding of a range of bytes.
 */
NS_SWIFT_NAME(EncodingRange)
SDC_EXPORTED_SYMBOL
@interface SDCEncodingRange : NSObject

/**
 * Charset encoding name as defined by IANA.
 */
@property (nonatomic, nonnull, readonly) NSString *ianaName;
/**
 * Start index of this encoding range
 */
@property (nonatomic, readonly) NSUInteger startIndex;
/**
 * End index (first index after the last) of this encoding range.
 */
@property (nonatomic, readonly) NSUInteger endIndex;

@end

NS_ASSUME_NONNULL_END
