//
//  RootViewController.h
//  FontRenderingIssue
//
//  Created by Ironhide Games on 9/23/14.
//  Copyright __MyCompanyName__ 2014. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef APPORTABLE
#import <BridgeKit/AndroidViewOnSystemUiVisibilityChangeListener.h>
@interface RootViewController : UIViewController<AndroidViewOnSystemUiVisibilityChangeListener>
#else
@interface RootViewController : UIViewController
#endif

@end
