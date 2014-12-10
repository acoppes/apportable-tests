//
//  GoogleGameServicesApportable.h
//  GoogleGameServicesTest
//
//  Created by Ironhide Games on 12/8/14.
//
//

#import <BridgeKit/JavaObject.h>

#define GGS_CLIENT_NONE 0x00000000
#define GGS_CLIENT_GAMES 0x00000001
#define GGS_CLIENT_PLUS 0x00000002
#define GGS_CLIENT_SNAPSHOT 0x00000004

#define GGS_CLIENT_ALL (GGS_CLIENT_GAMES | GGS_CLIENT_PLUS | GGS_CLIENT_SNAPSHOT)

@interface GoogleGameServicesApportable : JavaObject

- (void) initGoogleApiClient:(int)clients;

- (void) connect;

- (void) disconnect;

- (BOOL) isConnected;

@end
