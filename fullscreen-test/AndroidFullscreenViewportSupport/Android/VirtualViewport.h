//
//  VirtualViewport.h
//  ViewportSupport
//
//  Created by Ironhide Games on 8/26/13.
//
//

#import <Foundation/Foundation.h>

@interface VirtualViewport : NSObject

@property (nonatomic, readwrite) CGSize screenSize;
@property (nonatomic, readwrite) CGSize virtualSize;

+ (VirtualViewport*) virtualViewportScreenSize:(CGSize)screenSize andVirtualSize:(CGSize)virtualSize;

+ (VirtualViewport*) autoAdjustViewport:(CGSize)screenSize withMinSize:(CGSize)minSize andMaxSize:(CGSize)maxSize;

- (float) virtualWidth;

- (float) virtualHeight;

- (float) getWidth;

- (float) getHeight;

- (float) getWidthForWidth:(float)screenWidth andHeight:(float)screenHeight;

- (float) getHeightForWidth:(float)screenWidth andHeight:(float)screenHeight;

+ (BOOL) insideBounds:(CGSize)size withMinSize:(CGSize)minSize andMaxSize:(CGSize)maxSize;

@end