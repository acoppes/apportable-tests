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
    
    [GoogleGameServicesApportable registerInstanceMethod:@"printText" selector:@selector(printText:) arguments:[NSString className], NULL];
    [GoogleGameServicesApportable registerInstanceMethod:@"initApi" selector:@selector(initApi) arguments:NULL];
    [GoogleGameServicesApportable registerInstanceMethod:@"connect" selector:@selector(connect) arguments:NULL];
    [GoogleGameServicesApportable registerInstanceMethod:@"disconnect" selector:@selector(disconnect) arguments:NULL];
    //     [VerdeUITextView registerInstanceMethod:@"isEditable" selector:@selector(editable) returnValue:[JavaClass boolPrimitive] arguments: NULL];
    [GoogleGameServicesApportable registerInstanceMethod:@"isConnected" selector:@selector(isConnected) returnValue:[JavaClass boolPrimitive] arguments:NULL];
}

+ (NSString *)className
{
    return @"com.ironhidegames.common.ggs.GoogleGameServicesApportable";
}

#pragma clang diagnostic pop

@end
