#import "MBtypes.h"
#import "MBOS.h"

#import "MButil.h"

#import "MBUI.h"

#define MIN_PC 6		/* OS >= MIN_PC means the OS is a PC OS */

static const char *osname[] = {"wingdows", "apple", "next", "sgi", "sun",
			       "palm", "os2", "bsd", "linux", "redhat", "hurd", "beos"};
#define NUM_OS (sizeof(osname) / sizeof(osname[0]))

static MBPicture *os[NUM_OS];		/* array of OS pictures*/
static MBMCursor *cursor[NUM_OS];		/* array of OS cursors (drag/drop) */

@implementation MBOS

- (void)OS_load_pix
{
	unsigned int i;
	for (i = 0; i < NUM_OS; i++) {
		[ui loadImageNamed:@(osname[i]) hasTransparency:YES outPicture:&os[i]];
		if (i != 0)
			[ui loadCursorNamed:@(osname[i]) mask:CURSOR_OWN_MASK outCursor:&cursor[i]];
	}
}

- (void)OS_draw:(int)index atX:(int)x y:(int)y
{
	[ui drawPicture:os[index] atX:x y:y];
}

- (int)width
{
	return [ui UI_picture_width:os[0]];
}

- (int)height
{
	return [ui UI_picture_height:os[0]];
}

- (void)OS_set_cursor:(int)index
{
	[ui setCursor:cursor[index]];
}

- (int)randomPC
{
	return (RAND(MIN_PC, NUM_OS - 1));
}

- (BOOL)isPC:(int)index
{
	return (index >= MIN_PC);
}

@end
