//
//  AndroidVisibilityUtils.m
//  kingdomrush
//
//  Created by Ironhide Games on 10/8/13.
//  Copyright (c) 2013 Ironhide Games. All rights reserved.
//

#import "AndroidVisibilityUtils.h"

@implementation AndroidVisibilityUtils

+ (void)hideVirtualButtons
{
#ifdef APPORTABLE
    UISystemInterfaceVisibilityStyle style = UISystemInterfaceVisibilityStyleLowProfile;
    [UIApplication sharedApplication].systemInterfaceVisibilityStyle = style;
#endif
}

+ (void)showVirtualButtons
{
#ifdef APPORTABLE
    UISystemInterfaceVisibilityStyle style = UISystemInterfaceVisibilityStyleVisible;
    [UIApplication sharedApplication].systemInterfaceVisibilityStyle = style;
#endif
}

@end
