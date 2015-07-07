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

+ (instancetype)newComputerWithSetup:(int)i;
- (void)draw;
- (BOOL)isComputerAtX:(int)locx y:(int)locy;
- (BOOL)isCompatibleWithSystem:(int)system;
+ (void)loadPictures;
@property (readonly) int width;
@property (readonly) int height;

#define COMPUTER_TOASTER 0	/* computer 0 is a toaster */

@end
