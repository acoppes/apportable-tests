//
//  HelloWorldLayer.m
//  FontRenderingIssue
//
//  Created by Ironhide Games on 9/23/14.
//  Copyright __MyCompanyName__ 2014. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "cocos2d.h"
#import "CCMoveBehaviorNode.h"
#import "FontManager.h"
#import "ZFont.h"
#import "FontLabelStringDrawing.h"
#import "AppDelegate.h"
#import "RootViewController.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
	// return the scene
	return scene;
}

- (void)onEnter
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
    [super onEnter];
    [self scheduleUpdate];
}

- (void)onExit
{
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [super onExit];
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        [self createContent];
	}
	return self;
}

- (void) createContent
{
    [self removeAllChildrenWithCleanup:YES];
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    _windowSize = winSize;
    
    if (winSize.width < winSize.height)
        winSize = CGSizeMake(winSize.height, winSize.width);
    
    CGSize minSize = CGSizeMake(480, 310);
    CGSize maxSize = CGSizeMake(568, 320);
    
    {
        CCSprite *s = [CCSprite node];
        s.textureRect = CGRectMake(0, 0, 1024, 768);
        s.color = ccc3(255, 255, 255);
        s.position = ccp(winSize.width * 0.5f, winSize.height * 0.5f);
        [self addChild:s];
    }
    
    {
        CCSprite *s = [CCSprite node];
        s.textureRect = CGRectMake(0, 0, maxSize.width, maxSize.height);
        s.color = ccc3(0, 0, 255);
        s.position = ccp(winSize.width * 0.5f, winSize.height * 0.5f);
        [self addChild:s];
    }
    
    {
        
        CCSprite *s = [CCSprite node];
        s.textureRect = CGRectMake(0, 0, minSize.width, minSize.height);
        s.color = ccc3(255, 0, 0);
        s.position = ccp(winSize.width * 0.5f, winSize.height * 0.5f);
        [self addChild:s];
    }
    
    {
        CCLabelTTF *l = [CCLabelTTF labelWithString:@"Some text" dimensions:CGSizeMake(100, 30)
                                          alignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeWordWrap fontName:@"Comic_Book" fontSize:20];
        l.anchorPoint = ccp(0.5, 0.5);
        l.color = ccc3(255, 255, 255);
        l.position = ccp(winSize.width * 0.5f, winSize.height * 0.5f);
        [self addChild:l z:2];
    }
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{

}

- (void)update:(ccTime)dt
{

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
