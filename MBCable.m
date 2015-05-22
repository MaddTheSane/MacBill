#import "MBtypes.h"
#import "MBCable.h"

#import "MButil.h"

#import "MBBill.h"
#import "MBCable.h"
#import "MBComputer.h"
#import "MBGame.h"
#import "MBNetwork.h"
#import "MBOS.h"
#import "MBSpark.h"
#import "MBUI.h"
#include <tgmath.h>

static MBGame *game;
static MBNetwork *network;
static MBSpark *spark;
static MBUI *ui;

#define SWAP(x, y) do {typeof(x) _t; _t = x; x = y; y = _t;} while(0)

@implementation MBCable

- (void)reverse
{
	SWAP(c1, c2);
	SWAP(x1, x2);
	SWAP(y1, y2);
}

+ (void)Cable_class_init:g :n :s :u
{
	game = g;
	network = n;
	spark = s;
	ui = u;
}

+ (MBCable *)Cable_setup
{
	MBCable *cable;
	MBComputer *comp1, *comp2;
	int cwidth, cheight;

	cable = [[self alloc] init];

	cable->c1 = RAND(0, [network countOfComputers] - 1);
	do {
		cable->c2 = RAND(0, [network countOfComputers] - 1);
	} while (cable->c2 == cable->c1);
	cable->active = 0;
	cable->index = 0;
	cable->delay = SPARK_DELAY([game level]);

	comp1 = [network computerAtIndex:cable->c1];
	comp2 = [network computerAtIndex:cable->c2];
	cwidth = [comp1 width];
	cheight = [comp1 height];
	cable->x1 = comp1->x + cwidth/3;
	cable->x2 = comp2->x + cwidth/3;
	cable->y1 = comp1->y + cheight/2;
	cable->y2 = comp2->y + cheight/2;

	return cable;
}

- (void)draw
{
	[ui UI_draw_line:x1 :y1 :x2 :y2];
	if (active) {
		int rx = x - [spark Spark_width]/2;
		int ry = y - [spark Spark_height]/2;
		[spark drawAtX:rx y:ry index:index];
	}
}

- (void)update
{
	MBComputer *comp1, *comp2;
	comp1 = [network computerAtIndex:c1];
	comp2 = [network computerAtIndex:c2];

	if (active) {
		if ((comp1->os == OS_WINGDOWS) == (comp2->os == OS_WINGDOWS))
			active = 0;
		else if (comp1->os == OS_WINGDOWS || comp2->os == OS_WINGDOWS) {
			int xdist, ydist;
			float sx, sy;

			if (comp2->os == OS_WINGDOWS)
				[self reverse];

			xdist = x2 - x;
			ydist = y2 - y;

			sx = xdist >= 0 ? 1.0 : -1.0;
			sy = ydist >= 0 ? 1.0 : -1.0;
			xdist = abs(xdist);
			ydist = abs(ydist);
			if (xdist == 0 && ydist == 0) {
				if (!comp2->busy) {
					int counter;
					if (comp2->os == OS_OFF)
						counter = NETWORK_COUNTER_OFF;
					else
						counter = NETWORK_COUNTER_BASE;
					[network incrementCounter:counter byValue:-1];
					[network incrementCounter:NETWORK_COUNTER_WIN
							    byValue:1];
					comp2->os = OS_WINGDOWS;
				}
				active = 0;
			}
			else if (MAX(xdist, ydist) < SPARK_SPEED) {
				x = x2;
				y = y2;
			}
			else {
				fx+=(xdist*SPARK_SPEED*sx)/(xdist+ydist);
				fy+=(ydist*SPARK_SPEED*sy)/(xdist+ydist);
				x = (int)fx;
				y = (int)fy;
			}
			index = 1 - index;
		}
	}
	else {
		if ((comp1->os == OS_WINGDOWS) == (comp2->os == OS_WINGDOWS))
			;
		else if (comp1->os == OS_WINGDOWS || comp2->os == OS_WINGDOWS) {
			active = 1;
			delay = SPARK_DELAY([game level]);
			if (comp2->os == OS_WINGDOWS)
				[self reverse];
			x = x1;
			fx = x1;
			y = y1;
			fy = y1;
		}
	}
}

- (int)Cable_onspark:(int)locx y:(int)locy
{
	if (!active)
		return 0;
	return (abs(locx - x) < [spark Spark_width] &&
		abs(locy - y) < [spark Spark_height]);
}

- (void)reset
{
	active = 0;
	delay = SPARK_DELAY([game level]);
}

@end
