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

+ (void)initializeJava
{
    [super initializeJava];
    
    [GoogleGameServicesApportable registerConstructor];
    
    [GoogleGameServicesApportable registerInstanceMethod:@"initGoogleApiClient" selector:@selector(initGoogleApiClient:) arguments:[JavaClass intPrimitive], NULL];
    [GoogleGameServicesApportable registerInstanceMethod:@"connect" selector:@selector(connect) arguments:NULL];
    [GoogleGameServicesApportable registerInstanceMethod:@"disconnect" selector:@selector(disconnect) arguments:NULL];
    [GoogleGameServicesApportable registerInstanceMethod:@"isConnected" selector:@selector(isConnected) returnValue:[JavaClass boolPrimitive] arguments:NULL];
}

+ (NSString *)className
{
    return @"com.ironhidegames.common.ggs.GoogleGameServicesApportable";
}

#pragma clang diagnostic pop

@end
