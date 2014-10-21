//
//  CCDirectorIOSWithCamera.m
//  ViewportSupport
//
//  Created by Ironhide Games on 8/26/13.
//
//

#import "CCDirectorIOSWithCamera.h"
#import "CustomCamera.h"

@implementation CCDirectorIOSWithCamera

- (id)init
{
    self = [super init];
    if (self) {
        _camera = nil;
    }
    return self;
}

- (void)setProjectionDelegate:(id<CCProjectionProtocol>)projectionDelegate
{
    _camera = nil;
    [super setProjectionDelegate:projectionDelegate];
    if ([projectionDelegate isKindOfClass:[CustomCamera class]]) {
        _camera = (CustomCamera*) projectionDelegate;
    }
}

- (CGPoint)convertToGL:(CGPoint)p
{
    if (_camera != nil)
        return [_camera convertToGL:p];
    return [super convertToGL:p];
}

- (CGPoint)convertToUI:(CGPoint)p
{
    if (_camera != nil)
        return [_camera convertToUI:p];
    return [super convertToUI:p];
}

-(CGSize) winSize
{
    if (_camera != nil)
        return [_camera virtualSize];
    return [super winSize];
}


@end
