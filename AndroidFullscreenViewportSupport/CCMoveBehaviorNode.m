//
//  CCMoveBehaviorNode.m
//  kingdomrush
//
//  Created by Ironhide Games on 6/13/13.
//  Copyright (c) 2013 Ironhide Games. All rights reserved.
//

#import "CCMoveBehaviorNode.h"

@implementation CCMoveBehaviorNode

+ (id) moveBehaviorNodeWithPriority:(int)priority
{
    CCMoveBehaviorNode *node = [[[CCMoveBehaviorNode alloc] init] autorelease];
    node->touchPriority_ = priority;
    return node;
}

- (void)onEnter
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:touchPriority_ swallowsTouches:NO];
	[super onEnter];
}

- (void)onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}

- (BOOL)containsTouchLocation:(UITouch *)touch
{
    CCSprite *node = (CCSprite*) self.parent;
    int offset = 0;
    CGRect rect = CGRectMake(node.quad.bl.vertices.x - offset, node.quad.bl.vertices.y - offset,
                             node.quad.tr.vertices.x - node.quad.bl.vertices.x + 2 * offset,
                             node.quad.tr.vertices.y - node.quad.bl.vertices.y + 2 * offset);
    rect = CC_RECT_PIXELS_TO_POINTS(rect);
    return CGRectContainsPoint(rect, [node convertTouchToNodeSpace:touch]);
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    
    if (![self containsTouchLocation:touch]) {
        return NO;
    }
    touchStartPosition_ = [self getTouchPosition:touch];
    return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint point = [self getTouchPosition:touch];
    CGPoint diff = ccpSub(point, touchStartPosition_);
    self.parent.position = ccpAdd(self.parent.position, diff);
    touchStartPosition_ = point;
}

-(CGPoint) getTouchPosition:(UITouch*)touch{
    return [self.parent convertToWorldSpace:[self.parent convertTouchToNodeSpace:touch]];
}

@end
