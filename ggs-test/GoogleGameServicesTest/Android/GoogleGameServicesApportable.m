//
//  GoogleGameServicesApportable.m
//  GoogleGameServicesTest
//
//  Created by Ironhide Games on 12/8/14.
//
//

#import "GoogleGameServicesApportable.h"

@implementation GoogleGameServicesApportable

+ (void)initializeJava
{
    [super initializeJava];
    
    [GoogleGameServicesApportable registerConstructor];
    
    [GoogleGameServicesApportable registerInstanceMethod:@"printText" selector:@selector(printText:) arguments:[NSString className], nil];
    [GoogleGameServicesApportable registerInstanceMethod:@"initApi" selector:@selector(initApi) arguments:nil];
    [GoogleGameServicesApportable registerInstanceMethod:@"connect" selector:@selector(connect) arguments:nil];
    [GoogleGameServicesApportable registerInstanceMethod:@"disconnect" selector:@selector(disconnect) arguments:nil];
    [GoogleGameServicesApportable registerInstanceMethod:@"checkConnection" selector:@selector(checkConnection) returnValue:[JavaObject boolPrimitive] arguments:nil];
}

+ (NSString *)className
{
    return @"com.ironhidegames.common.ggs.GoogleGameServicesApportable";
}

@end
