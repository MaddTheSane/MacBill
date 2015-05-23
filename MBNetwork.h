/* MBNetwork */

#import <Cocoa/Cocoa.h>

/* Counters */
typedef NS_ENUM(int, NETWORK_COUNTER) {
	NETWORK_COUNTER_OFF = 0,
	NETWORK_COUNTER_BASE,
	NETWORK_COUNTER_WIN
#define NETWORK_COUNTER_MAX 2
};

@class MBGame;
@class MBComputer;
@class MBCable;
@class MBBill;

@interface MBNetwork : NSObject
{
    IBOutlet MBGame *game;
}

- (void)Network_setup;
- (void)draw;
- (void)update;
- (void)Network_toasters;
- (MBComputer *)computerAtIndex:(int)index;
@property (readonly) int countOfComputers;
- (MBCable *)cableAtIndex:(int)index;
@property (readonly) int countOfCables;
- (void)clearStray:(MBBill *)bill;
- (void)incrementCounter:(NETWORK_COUNTER)counter byValue:(int)val;
- (int)countOfCounter:(NETWORK_COUNTER)counter;

@end
