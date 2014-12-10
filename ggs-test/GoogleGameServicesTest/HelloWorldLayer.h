//
//  HelloWorldLayer.h
//  FontRenderingIssue
//
//  Created by Ironhide Games on 9/23/14.
//  Copyright __MyCompanyName__ 2014. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

@class GoogleGameServicesApportable;

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <CCTargetedTouchDelegate>
{
    CGSize _windowSize;
    CGRect _screenBounds;
}

#ifdef APPORTABLE
@property (nonatomic, retain) GoogleGameServicesApportable *ggs;
#endif

@property (nonatomic, retain) CCLabelTTF *signedInLabel;
@property (readwrite) BOOL wasConnected;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
