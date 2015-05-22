/* MBUI */

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(int, MBCursorMap) {
	CURSOR_SEP_MASK = 0,
	CURSOR_OWN_MASK
};

typedef NS_ENUM(NSInteger, DialogContants) {
	DIALOG_NEWGAME = 0,
	DIALOG_PAUSEGAME,
	DIALOG_WARPLEVEL,
	DIALOG_HIGHSCORE,
	DIALOG_QUITGAME,
	DIALOG_STORY,
	DIALOG_RULES,
	DIALOG_ABOUT,
	DIALOG_SCORE,
	DIALOG_ENDGAME,
	DIALOG_ENTERNAME
#define DIALOG_MAX 10
};

@class MBAqua;

@interface MBUI : NSObject
{
    IBOutlet MBAqua *aqua;
}

- (void)UI_restart_timer;
- (void)UI_kill_timer;

- (void)UI_pause_game;
- (void)UI_resume_game;

- (void)UI_make_main_window:(int)size;

- (void)UI_popup_dialog:(int)index;
- (void)UI_set_cursor:(MBMCursor *)cursor;
- (void)UI_clear;
- (void)UI_refresh;
- (void)UI_draw:(MBPicture *)picture :(int)x :(int)y;
- (void)UI_draw_line:(int)x1 :(int)y1 :(int)x2 :(int)y2;
- (void)UI_draw_str:(const char *)str :(int)x :(int)y;

- (void)UI_set_pausebutton:(int)action;

- (void)UI_load_picture:(NSString*)name :(int)trans :(MBPicture **)pictp;
- (void)UI_load_picture_indexed:(NSString*)name :(int)index :(int)trans
			     :(MBPicture **)pictp;
- (int)UI_picture_width:(MBPicture *)pict;
- (int)UI_picture_height:(MBPicture *)pict;

- (void)UI_load_cursor:(NSString*)name :(MBCursorMap)masked :(MBMCursor **)cursorp;

- (int)UI_intersect:(int)x1 :(int)y1 :(int)w1 :(int)h1 :(int)x2 :(int)y2 :(int)w2 :(int)h2;

- (const char *)UI_dialog_string:(int)index;
- (const char *)UI_menu_string:(int)index;

- (void)UI_set_interval:(int)ti;

@end
