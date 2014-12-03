//
//  CCMoveBehaviorNode.h
//  kingdomrush
//
//  Created by Ironhide Games on 6/13/13.
//  Copyright (c) 2013 Ironhide Games. All rights reserved.
//

#import "cocos2d.h"

@interface CCMoveBehaviorNode : CCNode <CCTargetedTouchDelegate> {
    int touchPriority_;
    CGPoint touchStartPosition_;
}

+ (id) moveBehaviorNodeWithPriority:(int)priority;

@end
