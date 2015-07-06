#import "MBtypes.h"
#import "MBAqua.h"

#import "MBGame.h"
#import "MBUI.h"

#import "MBImageView.h"

#define DIALOG_OK		(YES)
#define DIALOG_CANCEL	(NO)

static NSTimer *timer = nil;
static NSImage *frame;
static BOOL menu_pause_enable_flag = NO;
static int screensize;

@implementation MBAqua
{
    NSArray *deathBillSounds;
}

// private
- (void)leave_window
{
	[ui pauseGame];
}

// private
- (void)enter_window
{
	[ui resumeGame];
}

// private
- (void)redraw_window
{
	[ui refresh];
}

// private
- (void)timer_tick
{
	[game update];
}

// private
- (NSInteger)runAlertPanel:(NSString *)name :(BOOL)needsAltBtn;
{
	NSString *strMsg, *strTitle, *strBtn1, *strBtn2;
	strTitle = NSLocalizedString([name stringByAppendingString:@"_dialog_str_title"], nil);
	strMsg   = NSLocalizedString([name stringByAppendingString:@"_dialog_str_msg"], nil);
	strBtn1  = NSLocalizedString([name stringByAppendingString:@"_dialog_str_btn1"], nil);
	if (needsAltBtn == YES) {
		strBtn2  = NSLocalizedString([name stringByAppendingString:@"_dialog_str_btn2"], nil);
	} else {
		strBtn2 = nil;
	}
	if ([name isEqualToString:@"score"]) {
		return NSRunAlertPanel(strTitle, strMsg, strBtn1, strBtn2, nil,
								game.level, game.score);
	} else {
		return NSRunAlertPanel(strTitle, @"%@", strBtn1, strBtn2, nil, strMsg);
	}
}

/*
 * Cursor handling
 */

- (void)aqua_set_cursor:(MBMCursor *)cursor
{
	[cursor->cursor set];
	if ([[[cursor->cursor image] name] compare:@"hand"
			options:NSCaseInsensitiveSearch
			range:NSMakeRange(0, 4)] == NSOrderedSame) {
		[NSCursor unhide];
		[view drawCursor:NO];
	} else {
		[NSCursor hide];
		[view drawCursor:YES];
	};
}

- (void)aqua_load_cursor:(NSString*)name :(MBCursorMap)masked :(MBMCursor **)cursorp
{
	MBMCursor *cursor = malloc(sizeof(MBMCursor));
	MBPicture *pict;
	[self aqua_load_picture:name :0 :&pict];
	cursor->cursor = [[NSCursor alloc] initWithImage:pict->img
						hotSpot:NSMakePoint([self aqua_picture_width:pict] / 2,
											[self aqua_picture_height:pict] / 2)];
	*cursorp = cursor;
}

/*
 * Pixmap handling
 */

- (void)aqua_load_picture:(NSString*)name :(int)trans :(MBPicture **)pictp
{
	MBPicture *pict = malloc(sizeof(MBPicture));
	pict->img = [NSImage imageNamed:name];
	*pictp = pict;
}

- (int)aqua_picture_width:(in MBPicture *)pict
{
	return [pict->img size].width;
}

- (int)aqua_picture_height:(in MBPicture *)pict
{
	return [pict->img size].height;
}

- (void)clearWindow
{
	[frame lockFocus];
	[[NSColor whiteColor] set];
	NSRectFill(NSMakeRect( 0,  0, screensize, screensize));
	[frame unlockFocus];
}

- (void)refreshWindow
{
	[view setSubimage:frame];
	[view setNeedsDisplay:YES];
}

- (void)drawImage:(MBPicture *)pict atX:(int)x y:(int)y
{
	y += [self aqua_picture_height:pict];
	[frame lockFocus];
	[pict->img dissolveToPoint:NSMakePoint(x, y) fraction:1.0];
	[frame unlockFocus];
}

- (void)drawLineFromX:(int)x1 y:(int)y1 toX:(int)x2 y:(int)y2
{
	NSBezierPath *bz = [NSBezierPath bezierPath]; 
	[frame lockFocus];
	[[NSColor blackColor] set];
	[bz moveToPoint:NSMakePoint(x1, y1)];
	[bz lineToPoint:NSMakePoint(x2, y2)];
	[bz stroke];
	[frame unlockFocus];
}

- (void)drawString:(NSString*)str atX:(int)x y:(int)y
{
	NSDictionary *attrs = nil;
	NSSize size = [str sizeWithAttributes:attrs];
	[frame lockFocus];
	[str drawAtPoint:NSMakePoint(x, y - size.height) withAttributes:attrs];
	[frame unlockFocus];
}

/*
 * Timer operations
 */

- (void)startTimerWithInterval:(int)ms
{
	timer = [NSTimer scheduledTimerWithTimeInterval:ms/1000.0 target:self
					 selector:@selector(timer_tick) userInfo:nil repeats:YES];
}

- (void)stopTimer
{
	if (!timer)
		return;
	[timer invalidate];
	timer = nil;
}

- (BOOL)isTimerActive
{
	return (!!timer);
}


- (void)aqua_popup_dialog:(DialogConstants)dialog
{
	switch (dialog) {
	case DialogConstantsEnterName:
		[NSApp runModalForWindow:[entry window]];
		[game addHighScore:[entry stringValue]];
		break;
	case DialogConstantsPauseGame:
		[self runAlertPanel:@"pause" :NO];
		break;
	case DialogConstantsEndGame:
		[self runAlertPanel:@"endgame" :NO];
		break;
	case DialogConstantsScore:
		[self runAlertPanel:@"score" :NO];
		break;
	case DialogConstantsHighScore:
		[self high_score:self];
		break;
        default:
            break;
	}
}

- (void)makeMainWindowSize:(int)size
{
	screensize = size;
	[[view window] setContentSize:NSMakeSize(size, size)];
	// create frame buffer
	frame = [[NSImage alloc] initWithSize:NSMakeSize(size, size)];
	[frame setFlipped:YES];
}

- (void)setPauseButton:(BOOL)action
{
	menu_pause_enable_flag = (action ? YES : NO);
}


- (IBAction)new_game:(id)sender
{
	NSInteger ret;
	ret = [self runAlertPanel:@"newgame" :YES];
	if (ret != NSAlertDefaultReturn) {
		return;
	}

	[ui killTimer];
	[game startAtLevel:1];
}

- (IBAction)pause_game:(id)sender
{
	[ui UI_popup_dialog:DialogConstantsPauseGame];
}

- (IBAction)quit_game:(id)sender
{
	[game quitGame];
}

- (IBAction)warp_level:(id)sender
{
	NSInteger ret;
	ret = [NSApp runModalForWindow:[warp window]];
	if (ret == DIALOG_OK) {
		int level = [warp intValue];
		if (level == 0) {
			level = 1;
		}
		[ui killTimer];
		[game startAtLevel:level];
	}
}

- (IBAction)high_score:(id)sender
{
	[NSApp runModalForWindow:highscore];
}

- (IBAction)story:(id)sender
{
    //NSString *strLocation = [[NSBundle mainBundle] pathForResource:@"story" ofType:@"rtf"];
    NSString *string = [NSString stringWithContentsOfFile:
      [[NSBundle mainBundle] pathForResource: @"story" ofType: @"txt"] encoding:NSUTF8StringEncoding error:NULL];
    NSLog(@"%@", [story_tv description]);
    [story_tv setString: string];
	[NSApp runModalForWindow:story];
}

- (IBAction)rules:(id)sender
{
    NSString *strLocation = [[NSBundle mainBundle] pathForResource:@"rules" ofType:@"rtf"];
    [rules_tv readRTFDFromFile:strLocation];
	[NSApp runModalForWindow:rules];
}

- (IBAction)about:(id)sender
{
	[NSApp runModalForWindow:about];
}

- (IBAction)pref:(id)sender
{
	NSInteger i, tmp, ret;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *keys[] = { @"fieldsize", @"interval", @"transparency" };
	id texts[] = { text_size, text_timer, text_trans };
	id sliders[] = { slider_size, slider_timer, slider_trans };

	for (i = 0; i < 3; i++) {
		tmp = [defaults integerForKey:keys[i]];
		[texts[i] setIntegerValue:tmp];
		[sliders[i] setIntegerValue:tmp];
	}
	ret = [NSApp runModalForWindow:[text_size window]];
	if (ret == DIALOG_OK) {
		for (i = 0; i < 3; i++) {
			[defaults setInteger:[texts[i] integerValue] forKey:keys[i]];
		}
	}
}

- (IBAction)modalOk:(id)sender
{
	[NSApp stopModalWithCode:DIALOG_OK];
	[[sender window] orderOut:sender];
}

- (IBAction)modalCancel:(id)sender
{
	[NSApp stopModalWithCode:DIALOG_CANCEL];
	[[sender window] orderOut:sender];
}


- (void)pressButtonAtX:(int)x y:(int)y
{
	[game pressButtonAtX:x y:y];
}

- (void)releaseButtonAtX:(int)x y:(int)y
{
	[game releaseButtonAtX:x y:y];
}


// NSApplication's delegate methods
- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
	// get userdefaults
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *s = [[NSBundle mainBundle] pathForResource:@"Defaults" ofType:@"plist"];
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:s];
	if (dict != nil) {
		[defaults registerDefaults:dict];
	}
	
	// if we don't have a value already
	// set default for animation interval
	if ([defaults integerForKey:@"interval"] == 0) {
		[defaults setInteger:200 forKey:@"interval"];
	}

	[[view window] center];
	// autosave frame info
	[[view window] setFrameAutosaveName:@"main"];
	[[view window] makeKeyAndOrderFront:self];
	// set username to name entry
	[entry setStringValue:NSUserName()];

	[game setSize:(int)[defaults integerForKey:@"fieldsize"]];
	[ui setInterval:(int)[defaults integerForKey:@"interval"]];
	[view setTransparency:(int)[defaults integerForKey:@"transparency"]];

    @autoreleasepool {
        NSMutableArray *tmpSounds = [NSMutableArray arrayWithCapacity:4];
        for (int i = 0; i < 4; i++) {
            NSSound *sound = [NSSound soundNamed:[NSString stringWithFormat:@"ahh%d", i]];
            [tmpSounds addObject:sound];
        }
        deathBillSounds = [tmpSounds copy];
    }
    
	[game Game_main];
}

- (void)playRandomDeathSound
{
    NSSound *sound = deathBillSounds[arc4random_uniform((UInt32)deathBillSounds.count)];
	[sound play];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
	NSInteger ret;
	ret = [self runAlertPanel:@"quit" :YES];
	if (ret != NSAlertDefaultReturn) {
		return NSTerminateCancel;
	}
	[game quitGame];
	return NSTerminateNow;
}


// NSWindow's delegate methods
- (void)windowDidResignKey:(NSNotification *)notification
{
	[self leave_window];
}

- (void)windowDidBecomeKey:(NSNotification *)notification
{
	[self enter_window];
}


// enable/disable menu item
- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
	if (menuItem == menu_pause) {
		return menu_pause_enable_flag;
	} else {
		return YES;
	}
}

@end
