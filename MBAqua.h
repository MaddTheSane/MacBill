/* MBAqua */

#import <Cocoa/Cocoa.h>
#import "MBUI.h"

struct MBMCursor {
	NSCursor *cursor;
};

struct MBPicture {
	NSImage *img;
};

@class MBUI;
@class MBGame;
@class MBImageView;

@interface MBAqua : NSObject <NSApplicationDelegate, NSWindowDelegate>
{
    IBOutlet MBGame *game;
    IBOutlet MBUI *ui;

    IBOutlet NSPanel *about;
    IBOutlet NSWindow *story;
    IBOutlet NSWindow *rules;
    IBOutlet NSTextField *warp;
    IBOutlet NSTextField *entry;
    IBOutlet NSPanel *highscore;
    IBOutlet MBImageView *view;

    IBOutlet NSMenuItem *menu_pause;
    IBOutlet NSTextField *text_size;
    IBOutlet NSTextField *text_timer;
    IBOutlet NSTextField *text_trans;
    IBOutlet NSSlider *slider_size;
    IBOutlet NSSlider *slider_timer;
    IBOutlet NSSlider *slider_trans;
    IBOutlet NSTextView *rules_tv;
    IBOutlet NSTextView *story_tv;
}

- (void)setCursorTo:(MBMCursor *)cursor;
- (void)loadCursorNamed:(NSString*)name mask:(MBCursorMap)masked outCursor:(MBMCursor **)cursorp;
- (void)loadPictureNamed:(NSString*)name hasTransparency:(BOOL)trans outPicture:(inout MBPicture **)pictp;
- (int)aqua_picture_width:(in MBPicture *)pict;
- (int)aqua_picture_height:(in MBPicture *)pict;
- (void)clearWindow;
- (void)refreshWindow;
- (void)drawImage:(MBPicture *)pict atX:(int)x y:(int)y;
- (void)drawLineFromX:(int)x1 y:(int)y1 toX:(int)x2 y:(int)y2;
- (void)drawString:(NSString*)str atX:(int)x y:(int)y;
- (void)startTimerWithInterval:(int)ms;
- (void)stopTimer;
@property (readonly, getter=isTimerActive) BOOL timerActive;

- (void)aqua_popup_dialog:(DialogConstants)dialog;
- (void)makeMainWindowSize:(int)size;
- (void)setPauseButton:(BOOL)action;

- (IBAction)new_game:(id)sender;
- (IBAction)pause_game:(id)sender;
- (IBAction)quit_game:(id)sender;
- (IBAction)warp_level:(id)sender;
- (IBAction)high_score:(id)sender;
- (IBAction)story:(id)sender;
- (IBAction)rules:(id)sender;
- (IBAction)about:(id)sender;
- (IBAction)pref:(id)sender;

- (IBAction)modalOk:(id)sender;
- (IBAction)modalCancel:(id)sender;

- (void)pressButtonAtX:(int)x y:(int)y;
- (void)releaseButtonAtX:(int)x y:(int)y;

- (void)playRandomDeathSound;

- (BOOL)validateMenuItem:(NSMenuItem*)menuItem;

@end
