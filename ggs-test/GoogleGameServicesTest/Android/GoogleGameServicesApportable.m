//
//  GoogleGameServicesApportable.m
//  GoogleGameServicesTest
//
//  Created by Ironhide Games on 12/8/14.
//
//

#import "GoogleGameServicesApportable.h"

#pragma clang diagnostic push

#pragma clang diagnostic ignored "-Wobjc-property-implementation"
#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation GoogleGameServicesApportable

@synthesize onConnectedListener = _onConnectedListener;

+ (void)initializeJava
{
    [super initializeJava];
    
    [GoogleGameServicesApportable registerConstructor];
    
    [GoogleGameServicesApportable registerInstanceMethod:@"initGoogleApiClient" selector:@selector(initGoogleApiClient:) arguments:[JavaClass intPrimitive], NULL];
    [GoogleGameServicesApportable registerInstanceMethod:@"connect" selector:@selector(_connect) arguments:NULL];
    [GoogleGameServicesApportable registerInstanceMethod:@"disconnect" selector:@selector(disconnect) arguments:NULL];
    [GoogleGameServicesApportable registerInstanceMethod:@"isConnected" selector:@selector(isConnected) returnValue:[JavaClass boolPrimitive] arguments:NULL];
    
    [GoogleGameServicesApportable registerCallback:@"onConnectedCallback" selector:@selector(onConnectedCallback) returnValue:NULL arguments:NULL];
}

- (void) connect {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activityResult:) name:AndroidActivityResultNotification object:[AndroidActivity currentActivity]];
    [self _connect];
}

+ (NSString *)className
{
    return @"com.ironhidegames.common.ggs.GoogleGameServicesApportable";
}

- (void) onConnectedCallback
{
    if (self.onConnectedListener) {
        self.onConnectedListener();
    }
}

- (void)activityResult:(NSNotification *)notif
{
    NSDictionary *userInfo = notif.userInfo;

    NSLog(@"Activity result: %@", [userInfo description]);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        int requestCode = [userInfo[AndroidActivityResultRequestCodeKey] intValue];
        int resultCode = [userInfo[AndroidActivityResultResultCodeKey] intValue];
        
        if (requestCode == GGS_CLIENT_RC_SIGN_IN && resultCode == -1)
        {
            @autoreleasepool {
                [self _connect];
                [[NSNotificationCenter defaultCenter] removeObserver:self name:AndroidActivityResultNotification object:[AndroidActivity currentActivity]];
            }
        }
        else
        {
//            [[GPPClient sharedInstance] notifyResultCode];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [[NSNotificationCenter defaultCenter] postNotificationName:GPPClientSignInNotification object:self userInfo:@{
//                                                                                                                                                    @"type" : @"connectionFailure",
//                                                                                                                                                    @"code" : @(resultCode)
//                                                                                                                                                    }];
//            });
        }
    });
}

- (void)dealloc
{
    [_onConnectedListener release];
    [super dealloc];
}

#pragma clang diagnostic pop

@end
