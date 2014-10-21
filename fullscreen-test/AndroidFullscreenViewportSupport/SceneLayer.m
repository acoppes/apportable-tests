//
//  HelloWorldLayer.m
//  FontRenderingIssue
//
//  Created by Ironhide Games on 9/23/14.
//  Copyright __MyCompanyName__ 2014. All rights reserved.
//


// Import the interfaces
#import "SceneLayer.h"
#import "cocos2d.h"
#import "CCMoveBehaviorNode.h"
#import "FontManager.h"
#import "ZFont.h"
#import "FontLabelStringDrawing.h"
#import "HelloWorldLayer.h"

// HelloWorldLayer implementation
@implementation SceneLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SceneLayer *layer = [SceneLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (void)onEnter
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
    [super onEnter];
}

- (void)onExit
{
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [super onExit];
}

- (void)onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
#ifdef APPORTABLE
    [UIApplication sharedApplication].systemInterfaceVisibilityStyle = UISystemInterfaceVisibilityStyleImmersiveAlways;
#endif
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]] ;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
