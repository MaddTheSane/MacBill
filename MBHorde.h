/* MBHorde */

#import <Cocoa/Cocoa.h>

/* Counters */
typedef NS_ENUM(int, HordeCounter) {
	HORDE_COUNTER_OFF = 0,
	HORDE_COUNTER_ON
#define HORDE_COUNTER_MAX 1
};

@class MBGame;
@class MBNetwork;
@class MBBill;

@interface MBHorde : NSObject
{
    IBOutlet MBGame *game;
    IBOutlet MBNetwork *network;
}

- (void)Horde_setup;
- (void)update:(int)iteration;
- (void)draw;
- (void)moveBill:(MBBill *)bill;
- (void)removeBill:(MBBill *)bill;
- (void)addBill:(MBBill *)bill;
- (MBBill *)strayClickedAtX:(int)x y:(int)y;
- (int)processClickAtX:(int)x y:(int)y;
- (void)incrementCounter:(HordeCounter)counter byValue:(int)val;
- (int)countOfCounterType:(HordeCounter)counter;

@end
