//
//  CCDirectorIOSWithCamera.h
//  ViewportSupport
//
//  Created by Ironhide Games on 8/26/13.
//
//

#import "CCDirectorIOS.h"

@class CustomCamera;

@interface CCDirectorIOSWithCamera : CCDirectorDisplayLink {
    CustomCamera *_camera;
}

@end
