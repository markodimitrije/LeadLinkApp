/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2017- Scandit AG. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <ScanditCaptureCore/SDCBase.h>
NS_ASSUME_NONNULL_BEGIN

/**
 * Holds information on the current context status. This information is available to data capture context listeners (see context:didChangeStatus: method).
 */
NS_SWIFT_NAME(ContextStatus)
SDC_EXPORTED_SYMBOL
@interface SDCContextStatus : NSObject

/**
 * A human readable representation of the current context status, containing more information about potential issues. In case there are no issues (isValid is YES), the message is empty.
 */
@property (nonatomic, nonnull, readonly) NSString *message;
/**
 * The context status code.
 */
@property (nonatomic, readonly) NSUInteger code;
/**
 * Whether the context is valid.
 */
@property (nonatomic, readonly) BOOL isValid;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
