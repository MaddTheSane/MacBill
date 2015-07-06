#import "MBtypes.h"
#import "MBNetwork.h"

#import "MButil.h"

#import "MBBill.h"
#import "MBCable.h"
#import "MBComputer.h"
#import "MBGame.h"
#import "MBOS.h"

#define STD_MAX_COMPUTERS 20

static NSMutableArray *computers = nil;
static int ncomputers;
static NSMutableArray *cables = nil;
static int ncables;
static int counters[NETWORK_COUNTER_MAX + 1]; 	/* number in each state */

@implementation MBNetwork

- (int)on:(int)level
{
	int normal = MIN(8 + level, STD_MAX_COMPUTERS);
	return (int)(normal * [game Game_scale:2]);
}

/* sets up network for each level */
- (void)Network_setup
{
	int i;	
	ncomputers = [self on:[game level]];
	if (computers != nil)
		while ([computers count] != 0) {
			[computers removeObjectAtIndex:0];
		}
		[computers release];
	if (cables != nil) {
		while ([cables count] != 0) {
			[cables removeObjectAtIndex:0];
		}
		[cables release];
	}
	computers = [[NSMutableArray alloc] init];
	for (i = 0; i < ncomputers; i++) {
		MBComputer *comp = [[MBComputer newComputerWithSetup:i] autorelease];
		if (comp != nil) {
			[computers addObject:comp];
		} else {
			ncomputers = i - 1;
			break;
		}
	}
	counters[NETWORK_COUNTER_OFF] = 0;
	counters[NETWORK_COUNTER_BASE] = ncomputers;
	counters[NETWORK_COUNTER_WIN] = 0;
	ncables = MIN([game level], ncomputers/2);
	cables = [[NSMutableArray alloc] init];
	for (i = 0; i < ncables; i++) {
		MBCable *tmpCable = [MBCable newCable];
		[cables addObject:tmpCable];
		[tmpCable release];
	}
}

/* redraws the computers at their location with the proper image */
- (void)draw
{
	int i;
	for (i = 0; i < ncables; i++)
		[(MBCable*)[cables objectAtIndex:i] draw];
	for (i = 0; i < ncomputers; i++)
		[(MBComputer*)[computers objectAtIndex:i] draw];
}

- (void)update
{
	int i;
	for (i = 0; i < ncables; i++)
		[(MBCable*)[cables objectAtIndex:i] update];
}

- (void)networkToasters
{
	int i;
	for (i = 0; i < ncomputers; i++) {
		((MBComputer *)[computers objectAtIndex:i])->type = COMPUTER_TOASTER;
		((MBComputer *)[computers objectAtIndex:i])->os = OS_OFF;
	}
	ncables = 0;
}

- (MBComputer *)computerAtIndex:(int)index
{
	return [computers objectAtIndex:index];
}

- (int)countOfComputers
{
	return ncomputers;
}

- (MBCable *)cableAtIndex:(int)index
{
	return [cables objectAtIndex:index];
}

- (int)countOfCables
{
	return ncables;
}

- (void)clearStray:(MBBill *)bill
{
	int i;
	for (i = 0; i < ncomputers; i++) {
		if (((MBComputer *)[computers objectAtIndex:i])->stray == bill)
			((MBComputer *)[computers objectAtIndex:i])->stray = NULL;
	}
}

- (void)incrementCounter:(NETWORK_COUNTER)counter byValue:(int)val
{
	counters[counter] += val;
}

- (int)countOfCounter:(NETWORK_COUNTER)counter
{
	return counters[counter];
}

@end
