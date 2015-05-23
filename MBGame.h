/* MBGame */

#import <Cocoa/Cocoa.h>

@class MBUI;
@class MBSpark;
@class MBOS;
@class MBScorelist;
@class MBNetwork;
@class MBHorde;
@class MBBucket;

@interface MBGame : NSObject
@property (assign) IBOutlet MBBucket *bucket;
@property (assign) IBOutlet MBHorde *horde;
@property (assign) IBOutlet MBNetwork *network;
@property (assign) IBOutlet MBOS *os;
@property (assign) IBOutlet MBScorelist *scorelist;
@property (assign) IBOutlet MBSpark *spark;
@property (assign) IBOutlet MBUI *ui;

- (void)startAtLevel:(int)newlevel;
- (void)quitGame;
- (void)warpToLevel:(int)lev;
- (void)addHighScore:(NSString *)str;
- (void)pressButtonAtX:(int)x y:(int)y;
- (void)releaseButtonAtX:(int)x y:(int)y;
- (void)update;

@property (readonly) int score;
@property (readonly) int level;
@property (readonly) int screenSize;
- (double)Game_scale:(int)dimensions;

- (void)Game_main;

- (void)setSize:(int)size;

@end
