/* MBBucket */

#import <Cocoa/Cocoa.h>

@class MBUI;
@class MBNetwork;

@interface MBBucket : NSObject
{
    IBOutlet MBNetwork *network;
    IBOutlet MBUI *ui;
}

- (void)loadPictures;
- (void)draw;
- (BOOL)clickedAtX:(int)x y:(int)y;
- (void)grabAtX:(int)x y:(int)y;
- (void)releaseAtX:(int)x y:(int)y;

@end
