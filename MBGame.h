/* MBGame */

/* #import <Cocoa/Cocoa.h> */
#import <AppKit/AppKit.h>

@class MBUI;
@class MBSpark;
@class MBOS;
@class MBScorelist;
@class MBNetwork;
@class MBHorde;
@class MBBucket;

@interface MBGame : NSObject
{
    IBOutlet MBBucket *bucket;
    IBOutlet MBHorde *horde;
    IBOutlet MBNetwork *network;
    IBOutlet MBOS *os;
    IBOutlet MBScorelist *scorelist;
    IBOutlet MBSpark *spark;
    IBOutlet MBUI *ui;
}

- (void)Game_start:(int)newlevel;
- (void)Game_quit;
- (void)Game_warp_to_level:(int)lev;
- (void)Game_add_high_score:(NSString *)str;
- (void)Game_button_press:(int)x y:(int)y;
- (void)Game_button_release:(int)x y:(int)y;
- (void)Game_update;

@property (readonly) int score;
@property (readonly) int level;
@property (readonly) int screenSize;
- (double)Game_scale:(int)dimensions;

- (void)Game_main;

- (void)Game_set_size:(int)size;

@end
