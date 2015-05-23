#import "MBtypes.h"
#import "MBHorde.h"

#import "MButil.h"

#import "MBBill.h"
#import "MBComputer.h"
#import "MBGame.h"
#import "MBNetwork.h"
#import "MBUI.h"

static MBBill *alive, *strays;
static int counters[HORDE_COUNTER_MAX + 1];

#define MAX_BILLS 100		/* max Bills per level */

#define UNLINK(bill, list)						\
	do {							\
		if ((bill)->next != NULL)			\
			(bill)->next->prev = (bill)->prev;	\
		if ((bill)->prev != NULL)			\
			(bill)->prev->next = (bill)->next;	\
		else if ((bill) == list)			\
			(list) = (bill)->next;			\
		(bill)->prev = NULL;				\
		(bill)->next = NULL;				\
	} while (0)

#define PREPEND(bill, list)					\
	do {							\
		(bill)->next = (list);				\
		if ((list) != NULL)				\
			(list)->prev = (bill);			\
		(list) = (bill);				\
	} while (0)

static int
max_at_once(unsigned int lev) {
	return MIN(2 + lev / 4, 12);
}

static int
between(unsigned int lev) {
	return MAX(14 - lev / 3, 10);
}

/*  Launches Bills whenever called  */
static void
launch(int max) {
	MBBill *bill;
	int n;
	int off_screen = counters[HORDE_COUNTER_OFF];

	if (max == 0 || off_screen == 0)
		return;
	n = RAND(1, MIN(max, off_screen));
	for (; n > 0; n--) {
		bill = [MBBill newBill];
		PREPEND(bill, alive);
	}
}

@implementation MBHorde

// private
- (int)on:(unsigned int)lev
{
	int perlevel = (int)((8 + 3 * lev) * [game Game_scale:2]);
	return MIN(perlevel, MAX_BILLS);
}

- (void)Horde_setup
{
	MBBill *bill;
	while (alive != NULL) {
		bill = alive;
		UNLINK(bill, alive);
		[bill release];
	}
	while (strays != NULL) {
		bill = strays;
		UNLINK(bill, strays);
		[bill release];
	}
	counters[HORDE_COUNTER_OFF] = [self on:[game level]];
	counters[HORDE_COUNTER_ON] = 0;
}

- (void)update:(int)iteration
{
	MBBill *bill, *next;
	int level = [game level];
	if (iteration % between(level) == 0)
		launch(max_at_once(level));
	for (bill = alive; bill != NULL; bill = next) {
		next = bill->next;
		[bill update];
	}
}

- (void)draw
{
	MBBill *bill;

	for (bill = strays; bill != NULL; bill = bill->next)
		[bill draw];
	for (bill = alive; bill != NULL; bill = bill->next)
		[bill draw];
}

- (void)moveBill:(MBBill *)bill
{
	UNLINK(bill, alive);
	PREPEND(bill, strays);
}

- (void)removeBill:(MBBill *)bill
{
	if (bill->state == BILL_STATE_STRAY)
		UNLINK(bill, strays);
	else
		UNLINK(bill, alive);
	[network clearStray:bill];
	[bill release];
}

- (void)addBill:(MBBill *)bill
{
	if (bill->state == BILL_STATE_STRAY)
		PREPEND(bill, strays);
	else
		PREPEND(bill, alive);
}

- (MBBill *)strayClickedAtX:(int)x y:(int)y
{
	MBBill *bill;

	for (bill = strays; bill != NULL; bill = bill->next) {
		if (![bill clickedStrayAtX:x y:y])
			continue;
		UNLINK(bill, strays);
		return bill;
	}
	return NULL;
}

- (int)processClickAtX:(int)x y:(int)y
{
	MBBill *bill;
	int counter = 0;

	for (bill = alive; bill != NULL; bill = bill->next) {
		if (bill->state == BILL_STATE_DYING ||
		    ![bill clickedAtX:x y:y])
			continue;
		if (bill->state == BILL_STATE_AT) {
			MBComputer *comp;
			comp = [network computerAtIndex:bill->target_c];
			comp->busy = 0;
			comp->stray = bill;
		}
		[bill killBill];
       	counter++;
	}
	return counter;
}

- (void)incrementCounter:(HordeCounter)counter byValue:(int)val
{
	counters[counter] += val;
}

- (int)countOfCounterType:(HordeCounter)counter
{
	return counters[counter];
}

@end
