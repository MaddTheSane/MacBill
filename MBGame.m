#import "MBtypes.h"
#import "MBGame.h"

#import "MButil.h"

#import "MBBill.h"
#import "MBBucket.h"
#import "MBComputer.h"
#import "MBCable.h"
#import "MBHorde.h"
#import "MBNetwork.h"
#import "MBOS.h"
#import "MBScorelist.h"
#import "MBSpark.h"
#import "MBUI.h"

#define SCREENSIZE 400

/* Game states */
typedef NS_ENUM(unsigned int, GameState) {
	STATE_PLAYING = 1,
	STATE_BETWEEN,
	STATE_END,
	STATE_WAITING
};

/* Score related constants */
#define SCORE_ENDLEVEL -1
#define SCORE_BILLPOINTS 5

static GameState state;
static int efficiency;
static int score, level, iteration;
static MBPicture *logo, *icon, *about;
static MBMCursor *defaultcursor, *downcursor;
static MBBill *grabbed;
static int screensize = SCREENSIZE;

@implementation MBGame

// private
- (void)setup_level:(int)newlevel
{
	level = newlevel;
	[horde Horde_setup];
	grabbed = NULL;
	[ui UI_set_cursor:defaultcursor];
	[network Network_setup];
	iteration = 0;
	efficiency = 0;
}

// private
- (void)update_info
{
	char str[80];
	int on_screen = [horde Horde_get_counter:HORDE_COUNTER_ON];
	int off_screen = [horde Horde_get_counter:HORDE_COUNTER_OFF];
	int base = [network countOfCounter:NETWORK_COUNTER_BASE];
	int off = [network countOfCounter:NETWORK_COUNTER_OFF];
	int win = [network countOfCounter:NETWORK_COUNTER_WIN];
	int units = [network countOfComputers];
	sprintf(str, "Bill:%d/%d  System:%d/%d/%d  Level:%d  Score:%d",
		on_screen, off_screen, base, off, win, level, score);
	[ui UI_draw_str:str :5 :screensize - 5];
	efficiency += ((100 * base - 10 * win) / units);
}

// private
- (void)draw_logo
{
	[ui UI_clear];
	[ui UI_draw:logo
		:(screensize - [ui UI_picture_width:logo]) / 2
		:(screensize - [ui UI_picture_height:logo]) / 2];
}

- (void)Game_start:(int)newlevel
{
	state = STATE_PLAYING;
	score = 0;
	[ui UI_restart_timer];
	[ui UI_set_pausebutton:1];
	[self setup_level:newlevel];
}

- (void)Game_quit
{
	[scorelist writeScoreList];
}

- (void)Game_warp_to_level:(int)lev
{
	if (state == STATE_PLAYING) {
		if (lev <= level)
			return;
		[self setup_level:lev];
	}
	else {
		if (lev <= 0)
			return;
		[self Game_start:lev];
	}
}

- (void)Game_add_high_score:(NSString *)str
{
	[scorelist addScoreWithName:str level:level score:score];
}

- (void)Game_button_press:(int)x y:(int)y
{
	int counter;

	if (state != STATE_PLAYING)
		return;
	[ui UI_set_cursor:downcursor];

	if ([bucket clickedAtX:x y:y]) {
		[bucket grabAtX:x y:y];
		return;
	}

	grabbed = [horde Horde_clicked_stray:x y:y];
	if (grabbed != NULL) {
		[os OS_set_cursor:grabbed->cargo];
		return;
	}

	counter = [horde Horde_process_click:x y:y];
	score += (counter * counter * SCORE_BILLPOINTS);
}

- (void)Game_button_release:(int)x y:(int)y
{
	int i;
	[ui UI_set_cursor:defaultcursor];

	if (state != STATE_PLAYING)
		return;

	if (grabbed == NULL) {
		[bucket releaseAtX:x y:y];
		return;
	}

	for (i = 0; i < [network countOfComputers]; i++) {
		MBComputer *computer = [network computerAtIndex:i];

		if ([computer Computer_on:x :y] &&
		    [computer Computer_compatible:grabbed->cargo] &&
		    (computer->os == OS_WINGDOWS || computer->os == OS_OFF)) {
			int counter;

			[network incrementCounter:NETWORK_COUNTER_BASE byValue:1];
			if (computer->os == OS_WINGDOWS)
				counter = NETWORK_COUNTER_WIN;
			else
				counter = NETWORK_COUNTER_OFF;
			[network incrementCounter:counter byValue:-1];
			computer->os = grabbed->cargo;
			[horde Horde_remove_bill:grabbed];
			grabbed = NULL;
			return;
		}
	}
	[horde Horde_add_bill:grabbed];
	grabbed = NULL;
}

- (void)Game_update
{
	char str[40];
	
	switch (state) {
		case STATE_PLAYING:
			[ui UI_clear];
			[bucket draw];
			[network Network_update];
			[network Network_draw];
			[horde Horde_update:iteration];
			[horde Horde_draw];
			[self update_info];
			if ([horde Horde_get_counter:HORDE_COUNTER_ON] +
				[horde Horde_get_counter:HORDE_COUNTER_OFF] == 0) {
				score += (level * efficiency / iteration);
				state = STATE_BETWEEN;
			}
			if (([network countOfCounter:NETWORK_COUNTER_BASE] +
				 [network countOfCounter:NETWORK_COUNTER_OFF]) <= 1)
				state = STATE_END;
			break;
		case STATE_END:
			[ui UI_set_cursor:defaultcursor];
			[ui UI_clear];
			[network Network_toasters];
			[network Network_draw];
			[ui UI_refresh];
			[ui UI_popup_dialog:DIALOG_ENDGAME];
			if ([scorelist isHighScore:score]) {
				[ui UI_popup_dialog:DIALOG_ENTERNAME];
			}
			[ui UI_popup_dialog:DIALOG_HIGHSCORE];
			[self draw_logo];
			[ui UI_kill_timer];
			[ui UI_set_pausebutton:0];
			state = STATE_WAITING;
			break;
		case STATE_BETWEEN:
			[ui UI_set_cursor:defaultcursor];
			sprintf(str, "After Level %d:\nScore: %d", level, score);
			[ui UI_popup_dialog:DIALOG_SCORE];
			state = STATE_PLAYING;
			[self setup_level:++level];
			break;
			
		case STATE_WAITING:
			break;
	}
	[ui UI_refresh];
	iteration++;
}

- (int)score
{
	return score;
}

- (int)level
{
	return level;
}

- (int)screenSize
{
	return screensize;
}

- (double)Game_scale:(int)dimensions
{
	double scale = (double)screensize / SCREENSIZE;
	double d = 1;
	for ( ; dimensions > 0; dimensions--)
		d *= scale;
	return (d);
}

- (void)Game_main
{
	[MBBill Bill_class_init:self :horde :network :os :ui];
	[MBCable Cable_class_init:self :network :spark :ui];
	[MBComputer Computer_class_init:self :network :os :ui];

	srandom(time(NULL) & 0x7fffffff);
	[ui UI_make_main_window:screensize];
	[ui UI_load_picture:"logo" :0 :&logo];
	[ui UI_load_picture:"icon" :0 :&icon];
	[ui UI_load_picture:"about" :0 :&about];
	[self draw_logo];
	[ui UI_refresh];

	[scorelist readScoreList];

	[ui UI_load_cursor:"hand_up" :CURSOR_SEP_MASK :&defaultcursor];
	[ui UI_load_cursor:"hand_down" :CURSOR_SEP_MASK :&downcursor];
	[ui UI_set_cursor:defaultcursor];

	[MBBill Bill_load_pix];
	[os OS_load_pix];
	[MBComputer Computer_load_pix];
	[bucket Bucket_load_pix];
	[spark Spark_load_pix];

	state = STATE_WAITING;
	[ui UI_set_pausebutton:0];
}


- (void)Game_set_size:(int)size
{
	if (size >= SCREENSIZE) {
		screensize = size;
	}
}

@end
