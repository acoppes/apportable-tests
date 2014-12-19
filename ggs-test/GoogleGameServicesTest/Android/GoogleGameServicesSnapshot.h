//
//  GoogleGameServicesSnapshot.h
//  GoogleGameServicesTest
//
//  Created by Ironhide Games on 12/8/14.
//
//

#import <BridgeKit/JavaObject.h>

@class GoogleGameServicesApportable;
@class GoogleGameServicesSnapshot;

typedef void (^SnapshotOpenListener)(GoogleGameServicesSnapshot *snapshot, int status);

@interface GoogleGameServicesSnapshot : JavaObject {
    SnapshotOpenListener _openListener;
}

@property (nonatomic, copy) SnapshotOpenListener openListener;

- (void) open:(NSString*)name;

- (BOOL) isLoaded;

- (BOOL) isOpening;

- (NSData*) getContentsBytes;

- (void) setGoogleGameServicesApportable:(GoogleGameServicesApportable*)googleGameServicesApportable;

- (void) setContentsBytes:(NSData*)bytes;

@end
