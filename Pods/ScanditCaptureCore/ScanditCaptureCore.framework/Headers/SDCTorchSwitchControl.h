/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2017- Scandit AG. All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "SDCControl.h"
#import "SDCBase.h"

@class SDCTorchSwitchControl;

NS_ASSUME_NONNULL_BEGIN

/**
 * Control that allows to toggle the torch on an off. The torch switch control hides itself automatically in case the active frame source doesn’t have a torch.
 *
 * You can add this control to a view by calling SDCDataCaptureView.addControl:.
 */
NS_SWIFT_NAME(TorchSwitchControl)
SDC_EXPORTED_SYMBOL
@interface SDCTorchSwitchControl : NSObject <SDCControl>

@end

NS_ASSUME_NONNULL_END
