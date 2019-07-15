/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2017- Scandit AG. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "SDCBase.h"
#import "SDCFrameSource.h"
#import "SDCCameraSettings.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_CLOSED_ENUM(NSUInteger, SDCCameraPosition) {
/**
     * The camera is attached at the back of the device and is facing away from the user
     */
    SDCCameraPositionWorldFacing,
/**
     * The camera is attached on the front of the device and facing towards the user.
     */
    SDCCameraPositionUserFacing,
/**
     * The camera position is unspecified.
     */
    SDCCameraPositionUnspecified
} NS_SWIFT_NAME(CameraPosition);

/**
 * Possible values for the torch state.
 */
typedef NS_CLOSED_ENUM(NSUInteger, SDCTorchState) {
/**
     * Value to indicate that the torch is turned off.
     */
    SDCTorchStateOff = 0,
/**
     * Value to indicate that the torch is turned on.
     */
    SDCTorchStateOn = 1
} NS_SWIFT_NAME(TorchState);

/**
 * Gives access to the built-in camera on iOS. It implements the SDCFrameSource protocol, and, as such can be set as the frame source for the SDCDataCaptureContext.
 *
 * Instances of this class are created through one of the factory methods defaultCamera, or cameraAtPosition:.
 *
 * The camera is started by changing the desired state to SDCFrameSourceStateOn.
 *
 * By default, the resolution of captured frames as well as auto-focus and exposure settings are chosen such that they work best for a variety of use-cases. To fine-tune recognition, the camera settings can be changed through applying new camera settings.
 */
NS_SWIFT_NAME(Camera)
SDC_EXPORTED_SYMBOL
@interface SDCCamera : NSObject <SDCFrameSource>

/**
 * Get the default camera of the device. This method is identical to calling cameraAtPosition: repeatedly, first with SDCCameraPositionWorldFacing, then with SDCCameraPositionUserFacing followed by SDCCameraPositionUnspecified, stopping after the first of these calls returns a non-nil instance.
 *
 * See cameraAtPosition: for a more detailed description of the method behavior.
 */
@property (class, nonatomic, nullable, readonly) SDCCamera *defaultCamera;
/**
 * YES for cameras that have a torch, NO for others.
 */
@property (nonatomic, readonly) BOOL isTorchAvailable;
/**
 * The direction that the camera faces.
 */
@property (nonatomic, readonly) SDCCameraPosition position;
/**
 * The desired torch state for this camera. By default, the torch state is SDCTorchStateOff. When setting the desired torch state to SDCTorchStateOn, the torch will be on as long as the camera is running (the camera’s state is SDCFrameSourceStateOn) and off otherwise.
 *
 * When setting the desired torch state for a camera that does not have a torch (isTorchAvailable is NO), this call has no effect.
 */
@property (nonatomic, assign) SDCTorchState desiredTorchState;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/**
 * Retrieve camera instance of the first camera at the provided position. In case the system does not have a camera at the provided position, nil is returned.
 *
 * When this method is called multiple times with the same argument, the same SDCCamera instance is returned. The SDCFrameSource.currentState of the camera as well as the settings depend on previous invocations. For example, if the camera is currently in use and is active, the camera’s SDCFrameSource.currentState will be SDCFrameSourceStateOn. The only guarantee about the state and settings is that when instance is initially created, the SDCFrameSource.currentState is SDCFrameSourceStateOff and has the default SDCCameraSettings.
 *
 * In case parts of your app use custom camera settings and others use the default settings, make sure to reset the camera to use the default settings when you need them by passing the default camera settings to applySettings:completionHandler: to ensure that you don’t have any other settings when you’d expect the defaults to be active.
 *
 * The camera object is returned if present, regardless whether the application has permissions to use it or not.
 */
+ (nullable SDCCamera *)cameraAtPosition:(SDCCameraPosition)position NS_SWIFT_NAME(init(position:));

/**
 * Construct a new camera with the provided JSON serialization. See Serialization for details.
 */
+ (nullable instancetype)cameraFromJSONString:(nonnull NSString *)jsonString
                                        error:(NSError *_Nullable *_Nullable)error
    NS_SWIFT_NAME(init(jsonString:));

/**
 * Apply the camera settings to the camera. The task will complete when the settings have been applied and the camera has switched to use the new settings. If the camera is currently in SDCFrameSourceStateOff state, the task will complete immediately. If, on the other hand, the camera is currently in SDCFrameSourceStateOn state, the settings will be modified on the fly.
 */
- (void)applySettings:(nonnull SDCCameraSettings *)settings
    completionHandler:(nullable void (^)(void))completionHandler;

/**
 * Convenience method for SDCFrameSource.switchToDesiredState:completionHandler:
 */
- (void)switchToDesiredState:(SDCFrameSourceState)state;
/**
 * Implemented from SDCFrameSource. See SDCFrameSource.switchToDesiredState:completionHandler:.
 */
- (void)switchToDesiredState:(SDCFrameSourceState)state
           completionHandler:(nullable void (^)(BOOL))completionHandler;

/**
 * Updates the camera according to a JSON serialization. See Serialization for details.
 */
- (BOOL)updateFromJSONString:(nonnull NSString *)jsonString
                       error:(NSError *_Nullable *_Nullable)error;

@end

NS_ASSUME_NONNULL_END
