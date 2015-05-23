#import "MBtypes.h"
#import "MBUI.h"

#import "MButil.h"

#import "MBGame.h"

#import "MBAqua.h"

static int playing;
static const char *dialog_strings[DIALOG_MAX + 1];
static const char *menu_strings[DIALOG_MAX + 1];
static int interval = 200;

@implementation MBUI
@synthesize aqua;

- (void)restartTimer
{
	[aqua startTimerWithInterval:interval];
}

- (void)killTimer
{
	[aqua stopTimer];
}

- (void)pauseGame
{
	if ([aqua isTimerActive])
		playing = 1;
	[self killTimer];
}

- (void)resumeGame
{
	if (playing && ![aqua isTimerActive])
		[self restartTimer];
	playing = 0;
}

- (void)makeMainWindowSize:(int)size
{
	[aqua makeMainWindowSize:size];
}

- (void)UI_popup_dialog:(DialogConstants)dialog
{
	[aqua aqua_popup_dialog:dialog];
}

- (void)setCursor:(MBMCursor *)cursor
{
	[aqua aqua_set_cursor:cursor];
}

- (void)clear
{
	[aqua clearWindow];
}

- (void)refresh
{
	[aqua refreshWindow];
}

- (void)drawPicture:(MBPicture *)pict atX:(int)x y:(int)y
{
	[aqua drawImage:pict atX:x y:y];
}

- (void)drawLineFromX:(int)x1 y:(int)y1 toX:(int)x2 y:(int)y2
{
	[aqua drawLineFromX:x1 y:y1 toX:x2 y:y2];
}

- (void)drawString:(NSString*)str atX:(int)x y:(int)y
{
	[aqua drawString:str atX:x y:y];
}

- (void)setPauseButton:(BOOL)action
{
	[aqua setPauseButton:action];
}

- (void)UI_load_picture_indexed:(NSString*)name :(int)index :(int)trans :(MBPicture **)pictp
{
	NSString *newname = [name stringByAppendingFormat:@"_%d", index];
	[self UI_load_picture:newname :trans :pictp];
}

- (void)UI_load_picture:(NSString*)name :(int)trans :(MBPicture **)pictp
{
	[aqua aqua_load_picture:name :trans :pictp];
}

- (int)UI_picture_width:(MBPicture *)pict
{
	return [aqua aqua_picture_width:pict];
}

- (int)UI_picture_height:(MBPicture *)pict
{
	return [aqua aqua_picture_height:pict];
}

- (void)UI_load_cursor:(NSString*)name :(MBCursorMap)masked :(MBMCursor **)cursorp
{
	[aqua aqua_load_cursor:name :masked :cursorp];
}

- (BOOL)UI_intersect:(int)x1 :(int)y1 :(int)w1 :(int)h1 :(int)x2 :(int)y2 :(int)w2 :(int)h2
{
	return ((abs(x2 - x1 + (w2 - w1) / 2) < (w1 + w2) / 2) &&
		(abs(y2 - y1 + (h2 - h1) / 2) < (h1 + h2) / 2));
}

- (const char *)dialogString:(DialogConstants)index
{
	return dialog_strings[index];
}

- (const char *)menuString:(DialogConstants)index
{
	return menu_strings[index];
}


- (void)setInterval:(int)ti
{
	interval = ti;
}

@end
