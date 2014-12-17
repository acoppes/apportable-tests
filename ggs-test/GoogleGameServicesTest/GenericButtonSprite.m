//
//  GenericButtonSprite.m
//  GoogleGameServicesTest
//
//  Created by Ironhide Games on 12/17/14.
//
//

#import "GenericButtonSprite.h"

@implementation GenericButtonSprite

+ (id) button:(CGSize)size listener:(GenericRectangleButtonListener)listener
{
    GenericButtonSprite *button = [self node];
    [button setTextureRect:CGRectMake(0, 0, size.width, size.height)];
    button.listener = listener;
    return button;
}

- (void)onClick
{
    self.listener(self);
}

- (BOOL)evalTouchCondition
{
    return YES;
}

- (CGRect)rect
{
    CGRect rect = CGRectMake(quad_.bl.vertices.x - 0,
                             quad_.bl.vertices.y - 0,
                             quad_.tr.vertices.x - quad_.bl.vertices.x + 2 * 0,
                             quad_.tr.vertices.y - quad_.bl.vertices.y + 2 * 0);
    return CC_RECT_PIXELS_TO_POINTS(rect);
}

- (void)onEnter
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [super onEnter];
}

- (void)onExit
{
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [super onExit];
}

- (BOOL)containsTouchLocation:(UITouch *)touch
{
    CGPoint p = [self convertTouchToNodeSpace:touch];
    CGRect r = [self rect];
    return CGRectContainsPoint(r, p);
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (![self evalTouchCondition])
        return NO;
    
    if (![self containsTouchLocation:touch]) {
        return NO;
    }

    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self onClick];
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
}

-(void) dealloc{
    [self.listener release];
    [super dealloc];
}

@end
