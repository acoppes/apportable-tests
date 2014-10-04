//
//  VirtualViewport.m
//  ViewportSupport
//
//  Created by Ironhide Games on 8/26/13.
//
//

#import "VirtualViewport.h"

@implementation VirtualViewport

+ (VirtualViewport*) virtualViewportScreenSize:(CGSize)screenSize andVirtualSize:(CGSize)virtualSize;
{
    VirtualViewport *virtualViewport = [[[VirtualViewport alloc] init] autorelease];
    virtualViewport->_virtualSize = virtualSize;
    virtualViewport->_screenSize = screenSize;
    return virtualViewport;
}

+ (VirtualViewport*) autoAdjustViewport:(CGSize)screenSize withMinSize:(CGSize)minSize andMaxSize:(CGSize)maxSize
{
    if (screenSize.width >= minSize.width && screenSize.width <= maxSize.width && screenSize.height >= minSize.height && screenSize.height <= maxSize.height)
        return [VirtualViewport virtualViewportScreenSize:screenSize andVirtualSize:CGSizeMake(screenSize.width, screenSize.height)];
    
    float aspect = screenSize.width / screenSize.height;
    
    {
        float scaleForMinSize = minSize.width / screenSize.width;
        float scaleForMaxSize = maxSize.width / screenSize.width;
        
        float virtualViewportWidth = roundf(screenSize.width * scaleForMaxSize);
        float virtualViewportHeight = roundf(virtualViewportWidth / aspect);
        
        if ([VirtualViewport insideBounds:CGSizeMake(virtualViewportWidth, virtualViewportHeight) withMinSize:minSize andMaxSize:maxSize])
            return [VirtualViewport virtualViewportScreenSize:screenSize andVirtualSize:CGSizeMake(virtualViewportWidth, virtualViewportHeight)];
        
        virtualViewportWidth = roundf(screenSize.width * scaleForMinSize);
        virtualViewportHeight = roundf(virtualViewportWidth / aspect);
        
        if ([VirtualViewport insideBounds:CGSizeMake(virtualViewportWidth, virtualViewportHeight) withMinSize:minSize andMaxSize:maxSize])
            return [VirtualViewport virtualViewportScreenSize:screenSize andVirtualSize:CGSizeMake(virtualViewportWidth, virtualViewportHeight)];
    }
    
    {
        float scaleForMinSize = minSize.height / screenSize.height;
        float scaleForMaxSize = maxSize.height / screenSize.height;
        
        float virtualViewportHeight = roundf(screenSize.height * scaleForMaxSize);
        float virtualViewportWidth = roundf(virtualViewportHeight * aspect);
        
        if ([VirtualViewport insideBounds:CGSizeMake(virtualViewportWidth, virtualViewportHeight) withMinSize:minSize andMaxSize:maxSize])
            return [VirtualViewport virtualViewportScreenSize:screenSize andVirtualSize:CGSizeMake(virtualViewportWidth, virtualViewportHeight)];
        
        virtualViewportHeight = roundf(screenSize.height * scaleForMinSize);
        virtualViewportWidth = roundf(virtualViewportHeight * aspect);
        
        if ([VirtualViewport insideBounds:CGSizeMake(virtualViewportWidth, virtualViewportHeight) withMinSize:minSize andMaxSize:maxSize])
            return [VirtualViewport virtualViewportScreenSize:screenSize andVirtualSize:CGSizeMake(virtualViewportWidth, virtualViewportHeight)];
    }
    
    return [VirtualViewport virtualViewportScreenSize:screenSize andVirtualSize:maxSize];
}

+ (BOOL) insideBounds:(CGSize)size withMinSize:(CGSize)minSize andMaxSize:(CGSize)maxSize {
    if (size.width < minSize.width || size.width > maxSize.width)
        return false;
    if (size.height < minSize.height || size.height > maxSize.height)
        return false;
    return true;
}

- (float) virtualWidth
{
    return _virtualSize.width;
}

- (float) virtualHeight
{
    return _virtualSize.height;
}

- (float) virtualAspectRatio
{
    return _virtualSize.width / _virtualSize.height;
}

- (float) getWidth
{
    return [self getWidthForWidth:_screenSize.width andHeight:_screenSize.height];
}

- (float) getHeight
{
    return [self getHeightForWidth:_screenSize.width andHeight:_screenSize.height];
}

- (float) getWidthForWidth:(float)screenWidth andHeight:(float)screenHeight
{
    float virtualAspect = _virtualSize.width / _virtualSize.height;
    float aspect = screenWidth / screenHeight;
    if (aspect > virtualAspect || (ABS(aspect - virtualAspect) < 0.01f)) {
        return _virtualSize.height * aspect;
    } else {
        return _virtualSize.width;
    }
}

- (float) getHeightForWidth:(float)screenWidth andHeight:(float)screenHeight
{
    float virtualAspect = _virtualSize.width / _virtualSize.height;
    float aspect = screenWidth / screenHeight;
    if (aspect > virtualAspect || (ABS(aspect - virtualAspect) < 0.01f)) {
        return _virtualSize.height;
    } else {
        return _virtualSize.width / aspect;
    }
}

@end
