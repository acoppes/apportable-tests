//
//  CustomCameraProjection.h
//  ViewportSupport
//
//  Created by Ironhide Games on 8/22/13.
//
//

#import <Foundation/Foundation.h>
#import "CCProtocols.h"

@class VirtualViewport;

@interface CustomCamera : NSObject<CCProjectionProtocol> {
    CGRect _viewport;
    float projection[16];
    float view[16];
    VirtualViewport *virtualViewport;
    CGPoint screenOffset;
    CGSize _desiredScreenSize, _originalScreenSize;
}

@property (nonatomic, retain) VirtualViewport *virtualViewport;

@property (nonatomic, readwrite) CGSize minSize;
@property (nonatomic, readwrite) CGSize maxSize;

+ (CustomCamera*) cameraWithScreenSize:(CGSize)screenSize minSize:(CGSize)minSize maxSize:(CGSize)maxSize;

//+ (CustomCamera*) cameraWithScreenSize:(CGSize)screenSize andOriginalScreenSize:(CGSize)originalScreenSize andVirtualViewport:(VirtualViewport*)virtualViewport;

- (CGPoint)convertToGL:(CGPoint)p;

- (CGPoint)convertToUI:(CGPoint)p;

- (CGSize) virtualSize;

- (void) updateProjection;

@end
