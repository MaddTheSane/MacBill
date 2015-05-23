/* MBUI */

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(int, MBCursorMap) {
	CURSOR_SEP_MASK = 0,
	CURSOR_OWN_MASK
};

typedef NS_ENUM(NSInteger, DialogConstants) {
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
@property (assign) IBOutlet MBAqua *aqua;

- (void)restartTimer;
- (void)killTimer;

- (void)pauseGame;
- (void)resumeGame;

- (void)makeMainWindowSize:(int)size;

- (void)UI_popup_dialog:(DialogConstants)index;
- (void)setCursor:(MBMCursor *)cursor;
- (void)clear;
- (void)refresh;
- (void)drawPicture:(MBPicture *)picture atX:(int)x y:(int)y;
- (void)drawLineFromX:(int)x1 y:(int)y1 toX:(int)x2 y:(int)y2;
- (void)drawString:(NSString*)str atX:(int)x y:(int)y;

- (void)setPauseButton:(BOOL)action;

- (void)UI_load_picture:(NSString*)name :(int)trans :(MBPicture **)pictp;
- (void)UI_load_picture_indexed:(NSString*)name :(int)index :(int)trans
			     :(MBPicture **)pictp;
- (int)UI_picture_width:(MBPicture *)pict;
- (int)UI_picture_height:(MBPicture *)pict;

- (void)UI_load_cursor:(NSString*)name :(MBCursorMap)masked :(MBMCursor **)cursorp;

- (BOOL)UI_intersect:(int)x1 :(int)y1 :(int)w1 :(int)h1 :(int)x2 :(int)y2 :(int)w2 :(int)h2;

- (const char *)dialogString:(DialogConstants)index;
- (const char *)menuString:(DialogConstants)index;

- (void)setInterval:(int)ti;

@end
