//
//  GoogleGameServicesApportable.m
//  GoogleGameServicesTest
//
//  Created by Ironhide Games on 12/8/14.
//
//

#import "GoogleGameServicesApportable.h"

#import <BridgeKit/AndroidActivity.h>

#pragma clang diagnostic push

#pragma clang diagnostic ignored "-Wobjc-property-implementation"
#pragma clang diagnostic ignored "-Wobjc-method-access"
#pragma clang diagnostic ignored "-Wincomplete-implementation"

#define LOG_TAG @"GoogleGameServicesApportable"

@implementation GoogleGameServicesApportable

@synthesize onConnectedListener = _onConnectedListener;

+ (void)initializeJava
{
    [super initializeJava];
    
    [GoogleGameServicesApportable registerConstructor];
    
    [GoogleGameServicesApportable registerInstanceMethod:@"initGoogleApiClient" selector:@selector(initGoogleApiClient:) arguments:[JavaClass intPrimitive], NULL];
    [GoogleGameServicesApportable registerInstanceMethod:@"connect" selector:@selector(_connect) arguments:NULL];
    [GoogleGameServicesApportable registerInstanceMethod:@"silentConnect" selector:@selector(_silentConnect) arguments:NULL];
    [GoogleGameServicesApportable registerInstanceMethod:@"disconnect" selector:@selector(disconnect) arguments:NULL];
    [GoogleGameServicesApportable registerInstanceMethod:@"isConnected" selector:@selector(isConnected) returnValue:[JavaClass boolPrimitive] arguments:NULL];
    
    [GoogleGameServicesApportable registerCallback:@"onConnectedCallback" selector:@selector(onConnectedCallback) returnValue:NULL arguments:NULL];
    [GoogleGameServicesApportable registerCallback:@"onConnectionFailedCallback" selector:@selector(onConnectionFailedCallback) returnValue:NULL arguments:NULL];
}

+ (NSString *)className
{
    return @"com.ironhidegames.common.ggs.GoogleGameServicesApportable";
}

- (void) connect {
    // tries to remove the observer before adding a new one
    NSLog(@"%@: connect, removing and adding observer", LOG_TAG);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AndroidActivityResultNotification object:[AndroidActivity currentActivity]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activityResult:) name:AndroidActivityResultNotification object:[AndroidActivity currentActivity]];
    [self _connect];
}

- (void) silentConnect {
    [self _silentConnect];
}

//- (void) connect:(BOOL)trySignInResolution
//{
//    if (trySignInResolution) {
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:AndroidActivityResultNotification object:[AndroidActivity currentActivity]];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activityResult:) name:AndroidActivityResultNotification object:[AndroidActivity currentActivity]];
//    }
//    [self _connect:trySignInResolution];
//}

- (void) onConnectedCallback
{
    NSLog(@"%@: connection success, calling callback", LOG_TAG);
    if (self.onConnectedListener) {
        self.onConnectedListener();
    }
}

- (void) onConnectionFailedCallback
{
    // tries to remove the observer if connection failed
    NSLog(@"%@: connection failed, removing observer", LOG_TAG);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AndroidActivityResultNotification object:[AndroidActivity currentActivity]];
    // derive the event to another listener...
}

- (void)activityResult:(NSNotification *)notif
{
    NSDictionary *userInfo = notif.userInfo;

    NSLog(@"%@: Activity result: %@", LOG_TAG, [userInfo description]);

    dispatch_async(dispatch_get_main_queue(), ^{
        
        int requestCode = [userInfo[AndroidActivityResultRequestCodeKey] intValue];
        int resultCode = [userInfo[AndroidActivityResultResultCodeKey] intValue];
        
        if (requestCode == GGS_CLIENT_RC_SIGN_IN) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:AndroidActivityResultNotification object:[AndroidActivity currentActivity]];
            
            if (resultCode == -1) {
                @autoreleasepool {
                    [self _connect];
                }
            }
        }
        
//        if (requestCode == GGS_CLIENT_RC_SIGN_IN && resultCode == -1)
//        {
//            @autoreleasepool {
//                [self _connect];
//            }
//        }
//        else
//        {
////            [[GPPClient sharedInstance] notifyResultCode];
////            dispatch_async(dispatch_get_main_queue(), ^{
////                [[NSNotificationCenter defaultCenter] postNotificationName:GPPClientSignInNotification object:self userInfo:@{
////                                                                                                                                                    @"type" : @"connectionFailure",
////                                                                                                                                                    @"code" : @(resultCode)
////                                                                                                                                                    }];
////            });
//        }
    });
}

// saves
- (GoogleGameServicesSnapshot*) openSnapshot:(NSString*)name listener:(SnapshotOpenListener)listener
{
    GoogleGameServicesSnapshot *snapshot = [[[GoogleGameServicesSnapshot init] alloc] autorelease];
    snapshot.openListener = listener;
    [snapshot setGoogleGameServicesApportable:self];
    [snapshot open:name];
    return snapshot;
}

- (void)dealloc
{
    [_onConnectedListener release];
    [super dealloc];
}

@end

@implementation GoogleGameServicesSnapshot

@synthesize openListener = _openListener;

+ (void)initializeJava
{
    [super initializeJava];
    
    [GoogleGameServicesSnapshot registerConstructor];
    
    [GoogleGameServicesSnapshot registerInstanceMethod:@"setGoogleGameServicesApportable" selector:@selector(setGoogleGameServicesApportable:) arguments:[GoogleGameServicesApportable className], NULL];
    
    [GoogleGameServicesSnapshot registerInstanceMethod:@"open" selector:@selector(_open:) arguments:[NSString className], NULL];
    [GoogleGameServicesSnapshot registerInstanceMethod:@"isLoaded" selector:@selector(isLoaded) returnValue:[JavaClass boolPrimitive] arguments:NULL];
    [GoogleGameServicesSnapshot registerInstanceMethod:@"isOpening" selector:@selector(isOpening) returnValue:[JavaClass boolPrimitive] arguments:NULL];
    [GoogleGameServicesSnapshot registerInstanceMethod:@"getContentsBytes" selector:@selector(_getContentsBytes) returnValue:[NSData className]  arguments:NULL];
    [GoogleGameServicesSnapshot registerInstanceMethod:@"setContentsBytes" selector:@selector(_setContentsBytes:) arguments:[NSData className], NULL];
    
    [GoogleGameServicesApportable registerCallback:@"openCallback" selector:@selector(openCallback:) returnValue:NULL arguments:[JavaClass intPrimitive], NULL];
}

+ (NSString *)className
{
    return @"com.ironhidegames.common.ggs.GoogleGameServicesSnapshot";
}

- (void) open:(NSString*)name;
{
    [self _open:name];
}

//- (BOOL) isLoaded
//{
//    // just in case that we need to modify this
//    return [self _isLoaded];
//}
//
//- (BOOL) isOpening
//{
//    // just in case that we need to modify this
//    return [self _isOpening];
//}

- (NSData*) getContentsBytes
{
    return [self _getContentsBytes];
}

- (void) setContentsBytes:(NSData*)bytes
{
    [self _setContentsBytes:bytes];
}

- (void) openCallback:(int)status
{
    if (self.openListener)
        self.openListener(self, status);
}

- (void)dealloc
{
    [_openListener release];
    [super dealloc];
}

@end

#pragma clang diagnostic pop