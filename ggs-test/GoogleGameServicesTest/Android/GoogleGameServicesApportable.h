//
//  GoogleGameServicesApportable.h
//  GoogleGameServicesTest
//
//  Created by Ironhide Games on 12/8/14.
//
//

#import <BridgeKit/JavaObject.h>

@interface GoogleGameServicesApportable : JavaObject

- (void) printText:(NSString*)text;

- (void) initApi;

- (void) connect;

- (void) disconnect;

- (bool) checkConnection;

@end
