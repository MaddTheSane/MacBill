/* MBAqua */

/* #import <Cocoa/Cocoa.h> */
#import <AppKit/AppKit.h>

struct MBMCursor {
	NSCursor *cursor;
};

struct MBPicture {
	NSImage *img;
};

@class MBUI;
@class MBGame;
@class MBImageView;

@interface MBAqua : NSObject <NSApplicationDelegate>
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

- (void)aqua_set_cursor:(MBMCursor *)cursor;
- (void)aqua_load_cursor:(const char *)name :(int)masked :(MBMCursor **)cursorp;
- (void)aqua_load_picture:(const char *)name :(int)trans :(MBPicture **)pictp;
- (int)aqua_picture_width:(MBPicture *)pict;
- (int)aqua_picture_height:(MBPicture *)pict;
- (void)aqua_clear_window;
- (void)aqua_refresh_window;
- (void)aqua_draw_image:(MBPicture *)pict :(int)x :(int)y;
- (void)aqua_draw_line:(int)x1 :(int)y1 :(int)x2 :(int)y2;
- (void)aqua_draw_string:(const char *)str :(int)x :(int)y;
- (void)aqua_start_timer:(int)ms;
- (void)aqua_stop_timer;
- (int)aqua_timer_active;

- (void)aqua_popup_dialog:(int)dialog;
- (void)aqua_make_main_window:(int)size;
- (void)aqua_set_pausebutton:(int)action;

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

- (BOOL)validateMenuItem:(NSMenuItem*)menuItem;

@end
