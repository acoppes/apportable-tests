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
#import "CustomCamera.h"
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
        
        //        NSDictionary *mydefaults = @{ @"a" : @"b" };
        //        [[NSUserDefaults standardUserDefaults] registerDefaults:mydefaults];
        //        [[NSUserDefaults standardUserDefaults] setValuesForKeysWithDictionary:mydefaults];
        
        //        [[NSUserDefaults standardUserDefaults] synchronize];
        //
        //        NSLog(@"SAVED VALUE: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"a"]);
        
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
#ifdef APPORTABLE
    NSLog(@"UIDevice - nativeSystemName: %@", [[UIDevice currentDevice] nativeSystemName]);
    NSLog(@"UIDevice - nativeCPUABI: %@", [[UIDevice currentDevice] nativeCPUABI]);
    NSLog(@"UIDevice - nativeModel: %@", [[UIDevice currentDevice] nativeModel]);
    NSLog(@"UIDevice - nativeProduct: %@", [[UIDevice currentDevice] nativeProduct]);
    NSLog(@"UIDevice - nativeManufacturer: %@", [[UIDevice currentDevice] nativeManufacturer]);
    NSLog(@"UIDevice - nativeSystemVersion: %@", [[UIDevice currentDevice] nativeSystemVersion]);
    // NSLog(@"UIDevice - nativeSDKVersion: %@", [[UIDevice currentDevice] nativeSDKVersion]);
    
    BOOL isCyanogenMod = [[UIDevice currentDevice] hasSystemFeature:@"com.cyanogenmod.android"];
    
    NSLog(@"UIDevice - is CyanogenMod: %@", isCyanogenMod ? @"true" : @"false");
//hasSystemFeature()
#endif
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
#ifdef APPORTABLE
    int currentStyle = [UIApplication sharedApplication].systemInterfaceVisibilityStyle;
    
    if (currentStyle == UISystemInterfaceVisibilityStyleVisible) {
        [UIApplication sharedApplication].systemInterfaceVisibilityStyle = UISystemInterfaceVisibilityStyleImmersiveAlways;
    } else {
        [UIApplication sharedApplication].systemInterfaceVisibilityStyle = UISystemInterfaceVisibilityStyleVisible;
    }
    
#endif
}

- (void)update:(ccTime)dt
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    
    if (!CGSizeEqualToSize(_windowSize, winSize)) {
        NSLog(@"director win size changed from %@ to %@", NSStringFromCGSize(_windowSize), NSStringFromCGSize(winSize));
        self->_windowSize = winSize;
    }
    
    if (!CGRectEqualToRect(_screenBounds, screenBounds)) {
        NSLog(@"main screen bounds changed from %@ to %@", NSStringFromCGRect(_screenBounds), NSStringFromCGRect(screenBounds));
        self->_screenBounds = screenBounds;
        
//        CustomCamera *customCamera = [CustomCamera cameraWithScreenSize:screenSize minSize:minSize maxSize:maxSize];
//        [[CCDirector sharedDirector] setProjectionDelegate:customCamera];
//        [[CCDirector sharedDirector] setProjection:kCCDirectorProjectionCustom];
        
        CGSize minSize = CGSizeMake(480, 310);
        CGSize maxSize = CGSizeMake(568, 320);
        
        CGSize screenSize = screenBounds.size;
        
        if (screenSize.width < screenSize.height)
            screenSize = CGSizeMake(screenSize.height, screenSize.width);
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        CustomCamera *customCamera = [CustomCamera cameraWithScreenSize:screenSize minSize:minSize maxSize:maxSize];
        [[CCDirector sharedDirector] setProjectionDelegate:customCamera];

//        [self lala:appDelegate.viewController.interfaceOrientation];
        
//        [appDelegate.window setNeedsLayout];
//        [appDelegate.window layoutIfNeeded];
        
        [[appDelegate.viewController view] setNeedsLayout];
        [[appDelegate.viewController view] layoutIfNeeded];
        
//        [customCamera updateProjection];
        

//        [[CCDirector sharedDirector].openGLView setFrame:screenBounds];
        
//        [[CCDirector sharedDirector].openGLView setNeedsLayout];
//        [[CCDirector sharedDirector].openGLView layoutIfNeeded];
        
//        [[CCDirector sharedDirector].openGLView layoutSubviews];

//        [[CCDirector sharedDirector] reshapeProjection:screenSize];
        
//        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.1f], [CCCallBlock actionWithBlock:^{
//            [customCamera updateProjection];
//        }], nil]];
        
        NSLog(@"Updated custom camera with new screen bounds size");
        
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:3.0f], [CCCallBlock actionWithBlock:^{
            [self createContent];
        }], nil]];
    }
}

- (void) lala:(UIInterfaceOrientation)toInterfaceOrientation
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect rect = CGRectZero;
    
    if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        rect = screenRect;
    
    else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
        rect.size = CGSizeMake( screenRect.size.height, screenRect.size.width );
    
//    EAGLView *glView = [EAGLView viewWithFrame:rect
//                                   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
//                                   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
//                        ];
//    
//    [glView setMultipleTouchEnabled:YES];
    
    // attach the openglView to the director
    CCDirector *director = [CCDirector sharedDirector];
//    [director setOpenGLView:glView];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window setFrame:rect];
    
    EAGLView *glView = [director openGLView];
    float contentScaleFactor = [director contentScaleFactor];
    
    if( contentScaleFactor != 1 ) {
        rect.size.width *= contentScaleFactor;
        rect.size.height *= contentScaleFactor;
    }
    
    glView.frame = rect;
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
