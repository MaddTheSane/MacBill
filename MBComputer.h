/* MBComputer */

#import <Cocoa/Cocoa.h>

@interface MBComputer : NSObject
{
@public
	int type;		/* CPU type */
	int os;			/* current OS */
	int x, y;		/* location */
	int busy;		/* is the computer being used? */
	MBBill *stray;
}

+ (void)Computer_class_init:g :n :o :u;

+ (MBComputer *)Computer_setup:(int)i;
- (void)draw;
- (BOOL)Computer_on:(int)locx :(int)locy;
- (BOOL)Computer_compatible:(int)system;
+ (void)Computer_load_pix;
@property (readonly) int width;
@property (readonly) int height;

#define COMPUTER_TOASTER 0	/* computer 0 is a toaster */

@end
