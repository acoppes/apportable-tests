//
//  CustomCameraProjection.m
//  ViewportSupport
//
//  Created by Ironhide Games on 8/22/13.
//
//

#import "CustomCamera.h"
#import "cocos2d.h"
#import "VirtualViewport.h"

#import "MatrixUtils.h"

@implementation CustomCamera

#define LOG_TAG @"CustomCamera"

@synthesize virtualViewport;

+ (VirtualViewport*) virtualViewportWithScreenSize:(CGSize)screenSize minSize:(CGSize)minSize maxSize:(CGSize)maxSize
{
    float aspectMin = minSize.width / maxSize.height;
    float aspectMax = maxSize.width / minSize.height;
    float aspect = screenSize.width / screenSize.height;
    
    CGSize croppedScreenSize = screenSize;
    
    VirtualViewport *virtualViewport;
    
    if (aspect > aspectMax) {
        CGSize bestSize = CGSizeMake(maxSize.width, minSize.height);
        float aspectBest = bestSize.width / bestSize.height;
        float newWidth = roundf(croppedScreenSize.height * aspectBest);
        croppedScreenSize.width = newWidth;
        virtualViewport = [VirtualViewport autoAdjustViewport:croppedScreenSize withMinSize:bestSize andMaxSize:bestSize];
    } else if (aspect < aspectMin) {
        CGSize bestSize = CGSizeMake(minSize.width, maxSize.height);
        float aspectBest = bestSize.width / bestSize.height;
        float newHeight = roundf(croppedScreenSize.width / aspectBest);
        croppedScreenSize.height = newHeight;
        virtualViewport = [VirtualViewport autoAdjustViewport:croppedScreenSize withMinSize:bestSize andMaxSize:bestSize];
    } else {
        virtualViewport = [VirtualViewport autoAdjustViewport:croppedScreenSize withMinSize:minSize andMaxSize:maxSize];
    }
    
    return virtualViewport;
}

+ (CustomCamera*) cameraWithScreenSize:(CGSize)screenSize minSize:(CGSize)minSize maxSize:(CGSize)maxSize
{
    VirtualViewport *virtualViewport = [CustomCamera virtualViewportWithScreenSize:screenSize minSize:minSize maxSize:maxSize];
  
    CustomCamera *camera = [[[CustomCamera alloc] initWithScreenSize:virtualViewport.screenSize andVirtualViewport:virtualViewport] autorelease];
    camera.minSize = minSize;
    camera.maxSize = maxSize;
    [camera updateScreenSize:screenSize];
    return camera;
}

- (id)initWithScreenSize:(CGSize)size andVirtualViewport:(VirtualViewport*)vv
{
    self = [super init];
    if (self) {
        _desiredScreenSize = size;
        _originalScreenSize = CGSizeMake(-1, -1);
        CCLOG(@"%@ - winSize: %@", LOG_TAG, NSStringFromCGSize(size));
        _viewport = CGRectMake(0, 0, size.width, size.height);
        self.virtualViewport = vv;
        CCLOG(@"%@ - viewport: %@", LOG_TAG, NSStringFromCGRect(_viewport));
    }
    return self;
}

-(void)updateScreenSize:(CGSize)screenSize
{
    if (CGSizeEqualToSize(screenSize, CGSizeMake(0, 0)))
        return;
    if (CGSizeEqualToSize(screenSize, _originalScreenSize))
        return;
    CGPoint diff = ccp(screenSize.width - _desiredScreenSize.width, screenSize.height - _desiredScreenSize.height);
    screenOffset = ccpMult(diff, 0.5);
    _originalScreenSize = screenSize;
}

- (void)updateVirtualViewport:(CGSize)screenSize
{
    if (CGSizeEqualToSize(screenSize, CGSizeMake(0, 0)))
        return;
    if (CGSizeEqualToSize(screenSize, _originalScreenSize))
        return;
    self.virtualViewport = [CustomCamera virtualViewportWithScreenSize:screenSize minSize:self.minSize maxSize:self.maxSize];
    _desiredScreenSize = virtualViewport.screenSize;
    _viewport = CGRectMake(0, 0, virtualViewport.screenSize.width, virtualViewport.screenSize.height);
}

-(void) updateProjection
{
//    CCDirector *director = [CCDirector sharedDirector];
//
//    CGSize winSize = [UIScreen mainScreen].bounds.size;
   // CGSize winSize = director.winSize;
//
    
//    [self updateVirtualViewport:winSize];
//    [self updateScreenSize:winSize];
    
    CCLOG(@"%@ - Custom update projection", LOG_TAG);
    
    float viewportWidth = [virtualViewport getWidth];
    float viewportHeight = [virtualViewport getHeight];
    
    CCLOG(@"%@ - virtual viewport size: %fx%f", LOG_TAG, viewportWidth, viewportHeight);
    
    float virtualWidth = [virtualViewport virtualWidth];
    float virtualHeight = [virtualViewport virtualHeight];
    
    CCLOG(@"%@ - virtual viewport virtual size: %fx%f", LOG_TAG, virtualWidth, virtualHeight);
    
    CCLOG(@"%@ - virtual viewport screen offset: %@", LOG_TAG, NSStringFromCGPoint(screenOffset));
    
    float zoom = CC_CONTENT_SCALE_FACTOR();
    
    CCLOG(@"%@ - scaleFactor - (%f)", LOG_TAG, zoom);

    CGPoint center = ccp(0.5, 0.5);
    
    float xoffset = virtualWidth * center.x * CC_CONTENT_SCALE_FACTOR();
    float yoffset = virtualHeight * center.y * CC_CONTENT_SCALE_FACTOR();
    
    float left = (-virtualWidth * 0.5) * zoom + xoffset;
    float right = (virtualWidth * 0.5) * zoom + xoffset;
    float top = (virtualHeight * 0.5) * zoom + yoffset;
    float bottom = (-virtualHeight * 0.5) * zoom + yoffset;
    
    glViewport(_viewport.origin.x + screenOffset.x * CC_CONTENT_SCALE_FACTOR(), _viewport.origin.y + screenOffset.y * CC_CONTENT_SCALE_FACTOR(), _viewport.size.width * CC_CONTENT_SCALE_FACTOR(), _viewport.size.height * CC_CONTENT_SCALE_FACTOR());
    
    matrix4ToIdentity(projection);
    matrix4ToIdentity(view);
    
    matrix4ToOrtho(projection, left, right, bottom, top, -1024 * CC_CONTENT_SCALE_FACTOR(), 1024 * CC_CONTENT_SCALE_FACTOR());
    
    CCLOG(@"%@ - left, right, bottom, top - (%f, %f, %f, %f)", LOG_TAG, left, right, bottom, top);
    
    glMatrixMode(GL_PROJECTION);
    glLoadMatrixf(projection);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
}

- (CGPoint)convertToGL:(CGPoint)p
{
    p.x -= screenOffset.x;
    p.y -= screenOffset.y;
    
    float fx = p.x / _viewport.size.width;
    float fy = 1.0f - (p.y / _viewport.size.height);
    return ccp (fx * [virtualViewport virtualWidth], fy * [virtualViewport virtualHeight]);
}

- (CGPoint)convertToUI:(CGPoint)p
{
    float fx = p.x / [virtualViewport virtualWidth];
    float fy = 1.0f - (p.y / [virtualViewport virtualHeight]);
    return ccp (fx * _viewport.size.width, fy * _viewport.size.height);
}

- (CGSize) virtualSize
{
    return CGSizeMake(virtualViewport.virtualWidth, virtualViewport.virtualHeight);
}

@end
