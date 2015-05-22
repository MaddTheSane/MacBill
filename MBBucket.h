/* MBBucket */

/* #import <Cocoa/Cocoa.h> */
#import <AppKit/AppKit.h>

@class MBUI;
@class MBNetwork;

@interface MBBucket : NSObject
{
    IBOutlet MBNetwork *network;
    IBOutlet MBUI *ui;
}

- (void)Bucket_load_pix;
- (void)draw;
- (BOOL)clickedAtX:(int)x y:(int)y;
- (void)grabAtX:(int)x y:(int)y;
- (void)releaseAtX:(int)x y:(int)y;

@end
