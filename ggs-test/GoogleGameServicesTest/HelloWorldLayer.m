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

#import "GenericButtonSprite.h"

#ifdef APPORTABLE
#import "GoogleGameServicesApportable.h"
#endif

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
   // [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
    [super onEnter];
    [self scheduleUpdate];
}

- (void)onExit
{
    // [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
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
        GenericButtonSprite * button = [GenericButtonSprite button:CGSizeMake(64, 64) listener:^(GenericButtonSprite *button) {
            
            NSLog(@"GoogleGameServicesApportable: touch connect");
            
#ifdef APPORTABLE
            if (![self.ggs isConnected]) {
                [self.signedInLabel setString:@"Connecting..."];
                [self.ggs connect];
            }
#endif
            
        }];
        button.color = ccc3(0, 0, 255);
        button.position = ccp(100, 100);
        [self addChild:button];
    }
    
    {
        GenericButtonSprite * button = [GenericButtonSprite button:CGSizeMake(64, 64) listener:^(GenericButtonSprite *button) {
            
            NSLog(@"GoogleGameServicesApportable: touch disconnect");

#ifdef APPORTABLE
            if ([self.ggs isConnected]) {
                [self.ggs disconnect];
                [self.signedInLabel setString:@"Not connected"];
            }
#endif
            
        }];
        button.color = ccc3(0, 0, 200);
        button.position = ccp(200, 100);
        [self addChild:button];
    }
    
    {
        GenericButtonSprite * button = [GenericButtonSprite button:CGSizeMake(64, 64) listener:^(GenericButtonSprite *button) {
            
            NSLog(@"GoogleGameServicesApportable: touch open snapshot");

#ifdef APPORTABLE
            if ([self.ggs isConnected]) {
                
                self.snapshot = [self.ggs openSnapshot:@"slot1" listener:^(GoogleGameServicesSnapshot *snapshot, int status){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSString *str = [[NSString alloc] initWithData:[snapshot getContentsBytes] encoding:NSUTF8StringEncoding];
//                        NSLog("loaded with status: %i, data: %@", status, str);
                        NSLog(@"loaded with status: %i, length: %i", status, [[snapshot getContentsBytes] length]);
                    });
                    
                }];
                
            }
#endif
            
        }];
        button.color = ccc3(0, 0, 200);
        button.position = ccp(300, 100);
        [self addChild:button];
    }
    
    {
        self.signedInLabel = [CCLabelTTF labelWithString:@"Not connected" dimensions:CGSizeMake(200, 30)
                                          alignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeWordWrap fontName:@"Comic_Book" fontSize:20];
        self.signedInLabel.anchorPoint = ccp(0.5, 0.5);
        self.signedInLabel.color = ccc3(255, 255, 255);
        self.signedInLabel.position = ccp(winSize.width * 0.5f, winSize.height * 0.5f);
        [self addChild:self.signedInLabel z:2];
    }
    
    self.wasConnected = NO;
    
#ifdef APPORTABLE
    self.ggs = [[[GoogleGameServicesApportable alloc] init] autorelease];
    NSLog(@"GoogleGameServicesApportable: BEFORE CALL");
    [self.ggs initGoogleApiClient:(GGS_CLIENT_PLUS | GGS_CLIENT_GAMES | GGS_CLIENT_SNAPSHOT)];
    NSLog(@"GoogleGameServicesApportable: AFTER CALL");
    
    __block HelloWorldLayer *layerBlock = self;
    
    self.ggs.onConnectedListener = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [layerBlock.signedInLabel setString:@"Connected"];
        });
    };
    
    [self.ggs silentConnect];
#endif
    
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return NO;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
//#ifdef APPORTABLE
//    bool connected = [self.ggs isConnected];
//    
//    if (!connected) {
//        [self.signedInLabel setString:@"Connecting..."];
//        [self.ggs connect];
//    } else {
//        [self.ggs disconnect];
//        [self.signedInLabel setString:@"Not connected"];
//    }
//#endif
    
//    if (p.x > winSize.width / 2) {
//        NSLog(@"GoogleGameServicesApportable: Calling connect");
//#ifdef APPORTABLE
//        [self.signedInLabel setString:@"Connecting..."];
//        [self.ggs connect];
//#endif
//    } else {
//        NSLog(@"GoogleGameServicesApportable: Calling disconnect");
//#ifdef APPORTABLE
//        [self.ggs disconnect];
//        [self.signedInLabel setString:@"Not connected..."];
//#endif
//    }
    
}

- (void)update:(ccTime)dt
{
#ifdef APPORTABLE
    
    if (self.snapshot) {
        
    }
    
#endif
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
#ifdef APPORTABLE
    [_ggs release];
#endif
    
    [_signedInLabel release];
    
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
