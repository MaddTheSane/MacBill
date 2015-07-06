/* MBUI */

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(int, MBCursorMap) {
	CURSOR_SEP_MASK = 0,
	CURSOR_OWN_MASK
};

typedef NS_ENUM(NSInteger, DialogConstants) {
	DialogConstantsNewGame = 0,
	DialogConstantsPauseGame,
	DialogConstantsWarpToLevel,
	DialogConstantsHighScore,
	DialogConstantsQuitGame,
	DialogConstantsStory,
	DialogConstantsRules,
	DialogConstantsAbout,
	DialogConstantsScore,
	DialogConstantsEndGame,
	DialogConstantsEnterName
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

- (void)loadImageNamed:(NSString*)name hasTransparency:(BOOL)trans outPicture:(inout MBPicture **)pictp;
- (void)loadImageNamed:(NSString*)name atIndex:(int)index
		   hasTransparency:(BOOL)trans outPicture:(inout MBPicture **)pictp;
- (int)UI_picture_width:(in MBPicture *)pict;
- (int)UI_picture_height:(in MBPicture *)pict;

- (void)loadCursorNamed:(NSString*)name mask:(MBCursorMap)masked outCursor:(inout MBMCursor **)cursorp;

- (BOOL)UI_intersect:(int)x1 :(int)y1 :(int)w1 :(int)h1 :(int)x2 :(int)y2 :(int)w2 :(int)h2;

- (const char *)dialogString:(DialogConstants)index;
- (const char *)menuString:(DialogConstants)index;

@property int interval;

@end
