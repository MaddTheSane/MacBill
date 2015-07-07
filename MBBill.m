#import "MBtypes.h"
#import "MBBill.h"

#import "MButil.h"

#import "MBComputer.h"
#import "MBGame.h"
#import "MBHorde.h"
#import "MBNetwork.h"
#import "MBOS.h"
#import "MBUI.h"
#import "MBAqua.h"

/* speed at which OS drops */
#define GRAVITY 3

/* speed of moving Bill */
#define SLOW 0
#define FAST 1

#define WCELS 4                 /* # of bill walking animation frames */
#define DCELS 5                 /* # of bill dying animation frames */
#define ACELS 13                /* # of bill switching OS frames */

static MBPicture *lcels[WCELS], *rcels[WCELS], *acels[ACELS], *dcels[DCELS];
static int width, height;

static MBGame *game;
static MBHorde *horde;
static MBNetwork *network;
static MBOS *os;
static MBUI *ui;

static void
get_border(int *x, int *y) {
	int i = RAND(0, 3);
	int screensize = [game screenSize];

	if (i % 2 == 0)
		*x = RAND(0, screensize - width);
	else
		*y = RAND(0, screensize - height);

	switch (i) {
		case 0:
			*y = -height - 16;
			break;
		case 1:
			*x = screensize + 1;
			break;
		case 2:
			*y = screensize + 1;
			break;
		case 3:
			*x = -width - 2;
			break;
	}
}

static int
step_size(unsigned int level) {
	return MIN(11 + level, 15);
}


@implementation MBBill
@synthesize state;
@synthesize x;
@synthesize y;

/*  Moves bill toward his target - returns whether or not he moved */
static BOOL
move(MBBill *bill, int mode) {
	int xdist = bill->target_x - bill->x;
	int ydist = bill->target_y - bill->y;
	int step = step_size([game level]);
	int dx, dy;
	int signx = xdist >= 0 ? 1 : -1;
	int signy = ydist >= 0 ? 1 : -1;
	xdist = abs(xdist);
	ydist = abs(ydist);
	if (!xdist && !ydist)
		return NO;
	else if (xdist < step && ydist < step) {
		bill->x = bill->target_x;
		bill->y = bill->target_y;
	}
	else {
		dx = (xdist*step*signx)/(xdist+ydist);
		dy = (ydist*step*signy)/(xdist+ydist);
		if (mode == FAST) {
			dx *= 1.25;
			dy *= 1.25;
		}
		bill->x += dx;
		bill->y += dy;
		if (dx < 0)
			bill->cels = lcels;
		else if (dx > 0)
			bill->cels = rcels;
	}
	return YES;
}

- (void)drawStandard
{
	if (cargo >= 0)
		[os OS_draw:cargo atX:x + x_offset
				  y:y + y_offset];
	[ui drawPicture:cels[index] atX:x y:y];
}

- (void)drawAt {
	MBComputer *computer = [network computerAtIndex:target_c];
	if (index > 6 && index < 12)
		[os OS_draw:0 atX:x + sx y:y + sy];
	if (cargo >= 0)
		[os OS_draw:cargo atX:x + x_offset
				  y:y + y_offset];
	[ui drawPicture:cels[index] atX:computer->x y:computer->y];
}

-(void)drawStray {
	[os OS_draw:cargo atX:x y:y];
}

/*  Update Bill's position */
- (void)updatePosition
{
	int moved = move(self, SLOW);
	MBComputer *computer = [network computerAtIndex:target_c];
	if (!moved && computer->os != OS_WINGDOWS && !computer->busy) {
		computer->busy = 1;
		cels = acels;
		index = 0;
		state = BILL_STATE_AT;
		return;
	}
	else if (!moved) {
		int i;
		do {
			i = RAND(0, [network countOfComputers] - 1);
		} while (i == target_c);
		computer = [network computerAtIndex:i];
		target_c = i;
		target_x = computer->x + [computer width] - BILL_OFFSET_X;
		target_y = computer->y + BILL_OFFSET_Y;
	}
	index++;
	index %= WCELS;
	y_offset += (8 * (index % 2) - 4);
}

/*  Update Bill standing at a computer */
- (void)updateAtComputer
{
	MBComputer *computer = [network computerAtIndex:target_c];
	if (index == 0 && computer->os == OS_OFF) {
		index = 6;
		if (computer->stray == NULL)
			cargo = -1;
		else {
			cargo = computer->stray->cargo;
			[horde removeBill:computer->stray];
			computer->stray = NULL;
		}
	} else
		index++;
	if (index == 13) {
		y_offset = -15;
		x_offset = -2;
		get_border(&target_x, &target_y);
		index = 0;
		cels = lcels;
		state = BILL_STATE_OUT;
		computer->busy = 0;
		return;
	}
	y_offset = height - [os height];
	switch (index) {
		case 1:
		case 2:
			x -= 8;
			x_offset +=8;
			break;
		case 3:
			x -= 10;
			x_offset +=10;
			break;
		case 4:
			x += 3;
			x_offset -=3;
			break;
		case 5:
			x += 2;
			x_offset -=2;
			break;
		case 6:
			if (computer->os != OS_OFF) {
				[network incrementCounter:NETWORK_COUNTER_BASE byValue: -1];
				[network incrementCounter:NETWORK_COUNTER_OFF byValue: 1];
				cargo = computer->os;
			} else {
				x -= 21;
				x_offset += 21;
			}
			computer->os = OS_OFF;
			y_offset = -15;
			x += 20;
			x_offset -=20;
			break;
		case 7:
			sy = y_offset;
			sx = -2;
			break;
		case 8:
			sy = -15;
			sx = -2;
			break;
		case 9:
			sy = -7;
			sx = -7;
			x -= 8;
			x_offset +=8;
			break;
		case 10:
			sy = 0;
			sx = -7;
			x -= 15;
			x_offset +=15;
			break;
		case 11:
			sy = 0;
			sx = -7;
			computer->os = OS_WINGDOWS;
			[network incrementCounter:NETWORK_COUNTER_OFF byValue: -1];
			[network incrementCounter:NETWORK_COUNTER_WIN byValue: 1];
			break;
		case 12:
			x += 11;
			x_offset -=11;
	}
}

/* Updates Bill fleeing with his ill gotten gain */
- (void)updateOut
{
	int screensize = [game screenSize];
	if ([ui UI_intersect:x :y :width :height :0 :0
						:screensize :screensize])
	{
		move(self, FAST);
		index++;
		index %= WCELS;
		y_offset += (8*(index%2)-4);
	}
	else {
		[horde removeBill:self];
		[horde incrementCounter:HORDE_COUNTER_ON byValue:-1];
		[horde incrementCounter:HORDE_COUNTER_OFF byValue:1];
	}
}


/* Updates a Bill who is dying */
- (void)updateDying {
	if (index < DCELS - 1){
		y_offset += (index * GRAVITY);
		index++;
	}
	else {
		y += y_offset;
		if (cargo < 0 || cargo == OS_WINGDOWS)
			[horde removeBill:self];
		else {
			[horde moveBill:self];
			state = BILL_STATE_STRAY;
		}
		[horde incrementCounter:HORDE_COUNTER_ON byValue:-1];
	}
}


+ (void)Bill_class_init:g :h :n :o :u
{
	game = g;
	horde = h;
	network = n;
	os = o;
	ui = u;
}

/* Adds a bill to the in state */
+ (instancetype)newBill
{
	MBBill *bill;
	MBComputer *computer;

	bill = [[self alloc] init];

	bill->state = BILL_STATE_IN;
	get_border(&bill->x, &bill->y);
	bill->index = 0;
	bill->cels = lcels;
	bill->cargo = OS_WINGDOWS;
	bill->x_offset = -2;
	bill->y_offset = -15;
	bill->target_c = RAND(0, [network countOfComputers] - 1);
	computer = [network computerAtIndex:bill->target_c];
	bill->target_x = computer->x + [computer width] - BILL_OFFSET_X;
	bill->target_y = computer->y + BILL_OFFSET_Y;
	[horde incrementCounter:HORDE_COUNTER_ON byValue: 1];
	[horde incrementCounter:HORDE_COUNTER_OFF byValue: -1];
	bill->prev = NULL;
	bill->next = NULL;
	return bill;
}

- (void)draw
{
	switch (state) {
		case BILL_STATE_IN:
		case BILL_STATE_OUT:
		case BILL_STATE_DYING:
			[self drawStandard];
			break;
		case BILL_STATE_AT:
			[self drawAt];
			break;
		case BILL_STATE_STRAY:
			[self drawStray];
			break;
		default:
			break;
	}
}

- (void)update
{
	switch (state) {
		case BILL_STATE_IN:
			[self updatePosition];
			break;
		case BILL_STATE_AT:
			[self updateAtComputer];
			break;
		case BILL_STATE_OUT:
			[self updateOut];
			break;
		case BILL_STATE_DYING:
			[self updateDying];
			break;
		default:
			break;
	}
}

- (void)killBill
{
	index = -1;
	cels = dcels;
	x_offset = -2;
	y_offset = -15;
	state = BILL_STATE_DYING;
	[ui.aqua playRandomDeathSound];
}

- (BOOL)clickedAtX:(int)locx y:(int)locy
{
	return (locx > x && locx < x + width &&
		locy > y && locy < y + height);
}

- (BOOL)clickedStrayAtX:(int)locx y:(int)locy
{
	return (locx > x && locx < x + [os width] &&
		locy > y && locy < y + [os height]);
}

+ (void)loadPictures
{
	int i;
	for (i = 0; i < WCELS - 1; i++) {
		[ui loadImageNamed:@"billL" atIndex:i hasTransparency:YES outPicture:&lcels[i]];
		[ui loadImageNamed:@"billR" atIndex:i hasTransparency:YES outPicture:&rcels[i]];
	}
	lcels[WCELS - 1] = lcels[1];
	rcels[WCELS - 1] = rcels[1];

	for (i = 0; i < DCELS; i++)
		[ui loadImageNamed:@"billD" atIndex:i hasTransparency:YES outPicture:&dcels[i]];
	width = [ui UI_picture_width:dcels[0]];
	height = [ui UI_picture_height:dcels[0]];

	for (i = 0; i < ACELS; i++)
		[ui loadImageNamed:@"billA" atIndex:i hasTransparency:YES outPicture:&acels[i]];
}

+ (int)width
{
	return width;
}

- (int)height
{
	return height;
}

@end
