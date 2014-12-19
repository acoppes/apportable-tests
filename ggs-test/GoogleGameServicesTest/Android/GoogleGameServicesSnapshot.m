//
//  GoogleGameServicesApportable.m
//  GoogleGameServicesTest
//
//  Created by Ironhide Games on 12/8/14.
//
//

#import "GoogleGameServicesSnapshot.h"
#import "GoogleGameServicesApportable.h"

#import <BridgeKit/AndroidActivity.h>

#pragma clang diagnostic push

#pragma clang diagnostic ignored "-Wobjc-property-implementation"
#pragma clang diagnostic ignored "-Wobjc-method-access"
#pragma clang diagnostic ignored "-Wincomplete-implementation"

#define LOG_TAG @"GoogleGameServicesSnapshot"

@implementation GoogleGameServicesSnapshot

@synthesize openListener = _openListener;

+ (void)initializeJava
{
    [super initializeJava];
    
    [GoogleGameServicesSnapshot registerConstructor];
    
    [GoogleGameServicesSnapshot registerInstanceMethod:@"open" selector:@selector(_open:) arguments:[NSString className], NULL];
    [GoogleGameServicesSnapshot registerInstanceMethod:@"isLoaded" selector:@selector(isLoaded) returnValue:[JavaClass boolPrimitive] arguments:NULL];
    [GoogleGameServicesSnapshot registerInstanceMethod:@"isOpening" selector:@selector(isOpening) returnValue:[JavaClass boolPrimitive] arguments:NULL];
    [GoogleGameServicesSnapshot registerInstanceMethod:@"setGoogleGameServicesApportable" selector:@selector(setGoogleGameServicesApportable:) returnValue:NULL arguments:[GoogleGameServicesApportable className], NULL];

    // content
    
    [GoogleGameServicesSnapshot registerInstanceMethod:@"isClosed" selector:@selector(isClosed) returnValue:[JavaClass boolPrimitive] arguments:NULL];
    [GoogleGameServicesSnapshot registerInstanceMethod:@"readFully" selector:@selector(_readFully) returnValue:[NSData className]  arguments:NULL];
    [GoogleGameServicesSnapshot registerInstanceMethod:@"modifyBytes" selector:@selector(_modifyBytes:) returnValue:[JavaClass boolPrimitive] arguments:[JavaClass intPrimitive], [NSData className], [JavaClass intPrimitive], [JavaClass intPrimitive], NULL];
    [GoogleGameServicesSnapshot registerInstanceMethod:@"writeBytes" selector:@selector(_writeBytes:) returnValue:[JavaClass boolPrimitive] arguments:[NSData className], NULL];
    
//    {
//        BOOL status =
//        
//        if (!status) {
//            [NSException raise:@"JavaMethodException" format:@"Failed to register method: %@", @"setGoogleGameServicesApportable"];
//        }
//    }
    
    [GoogleGameServicesSnapshot registerCallback:@"openCallback" selector:@selector(openCallback:) returnValue:NULL arguments:[JavaClass intPrimitive], NULL];
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

- (NSData*) readFully
{
    return [self _readFully];
}

- (BOOL) writeBytes:(NSData*)bytes
{
    return [self _writeBytes:bytes];
}

- (BOOL) modifyBytes:(int)dstOffset bytes:(NSData*)bytes srcOffset:(int)srcOffset count:(int)count
{
    return [self _modifyBytes:bytes];
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