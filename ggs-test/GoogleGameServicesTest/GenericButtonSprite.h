//
//  GenericButtonSprite.h
//  GoogleGameServicesTest
//
//  Created by Ironhide Games on 12/17/14.
//
//

#import "cocos2d.h"

@class GenericButtonSprite;

typedef void (^GenericRectangleButtonListener)(GenericButtonSprite* button);

@interface GenericButtonSprite : CCSprite <CCTargetedTouchDelegate>

@property (nonatomic,copy) GenericRectangleButtonListener listener;

+ (id) button:(CGSize)size listener:(GenericRectangleButtonListener)listener;

@end
