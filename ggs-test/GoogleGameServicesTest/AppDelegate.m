//
//  AppDelegate.m
//  FontRenderingIssue
//
//  Created by Ironhide Games on 9/23/14.
//  Copyright __MyCompanyName__ 2014. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "GameConfig.h"
#import "HelloWorldLayer.h"
#import "RootViewController.h"

#define COCOS2D_DEBUG 1

@implementation AppDelegate

@synthesize window;
@synthesize viewController;

-(BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // UISystemInterfaceVisibilityStyleImmersiveAlways
    
#ifdef APPORTABLE
    [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenAspectFitEmulationMode];
#endif
    
    UIScreen *mainScreen = [UIScreen mainScreen];
	window = [[UIWindow alloc] initWithFrame:[mainScreen bounds]];
	
    CCDirector *director = [CCDirector sharedDirector];
    [[CCDirector sharedDirector] setProjection:kCCDirectorProjection2D];
    
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
    CGRect windowBounds = [window bounds];
	EAGLView *glView = [EAGLView viewWithFrame:windowBounds
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
    
    [glView setMultipleTouchEnabled:YES];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
//	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/30];
	// [director setDisplayFPS:YES];
	
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
	// [window addSubview: viewController.view];
    window.rootViewController = viewController;
    
#ifndef APPORTABLE
    [window makeKeyAndVisible];
#endif
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
//#ifndef VIEWPORTADJUST
//    [[CCDirector sharedDirector] setProjection:kCCDirectorProjection2D];
//#endif
	
	// Run the intro Scene
	[[CCDirector sharedDirector] runWithScene: [HelloWorldLayer scene]];
    
    // https://github.com/apportable/apportable/blob/a9f5f2ce30d5562a3ac25d60e0394668edd446c0/System/UIKit/src/android/UIApplication.m
    // UIWindow* window = [self keyWindow];
    // [window._proxy setSystemUiVisibility:androidInterfaceStyle];
    
#ifdef APPORTABLE
    [UIApplication sharedApplication].systemInterfaceVisibilityStyle = UISystemInterfaceVisibilityStyleImmersiveAlways;
#endif
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] end];
	[window release];
    [viewController release];
	[super dealloc];
}

#ifdef APPORTABLE
- (void)onSystemUiVisibilityChange:(int32_t)visibility
{
    NSLog(@"Window changed visibility: %d", visibility);
}
#endif

@end
