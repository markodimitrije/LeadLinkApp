/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2017- Scandit AG. All rights reserved.
 */

#import <Foundation/Foundation.h>

#import <ScanditCaptureCore/SDCBase.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * A sound, to be played for example when a code has been successfully scanned.
 */
NS_SWIFT_NAME(Sound)
SDC_EXPORTED_SYMBOL
@interface SDCSound : NSObject

/**
 * The default beep sound for a successful scan.
 */
@property (class, nonatomic, readonly) SDCSound *defaultSound;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/**
 * Creates a new Sound loading the given file.
 */
- (nullable instancetype)initWithURL:(nonnull NSURL *)url;

@end

NS_ASSUME_NONNULL_END
