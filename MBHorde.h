/* MBHorde */

#import <Cocoa/Cocoa.h>

/* Counters */
#define HORDE_COUNTER_OFF 0
#define HORDE_COUNTER_ON 1
#define HORDE_COUNTER_MAX 1

@class MBGame;
@class MBNetwork;
@class MBBill;

@interface MBHorde : NSObject
{
    IBOutlet MBGame *game;
    IBOutlet MBNetwork *network;
}

- (void)Horde_setup;
- (void)Horde_update:(int)iteration;
- (void)Horde_draw;
- (void)Horde_move_bill:(MBBill *)bill;
- (void)Horde_remove_bill:(MBBill *)bill;
- (void)Horde_add_bill:(MBBill *)bill;
- (MBBill *)Horde_clicked_stray:(int)x y:(int)y;
- (int)Horde_process_click:(int)x y:(int)y;
- (void)Horde_inc_counter:(int)counter value:(int)val;
- (int)Horde_get_counter:(int)counter;

@end
