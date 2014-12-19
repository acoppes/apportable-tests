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

- (void) setGoogleGameServicesApportable:(GoogleGameServicesApportable*)googleGameServicesApportable;

// content

- (BOOL) isClosed;

- (NSData*) readFully;

- (BOOL) writeBytes:(NSData*)bytes;

- (BOOL) modifyBytes:(int)dstOffset bytes:(NSData*)bytes srcOffset:(int)srcOffset count:(int)count;

@end
