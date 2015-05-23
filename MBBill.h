/* MBBill */

#import <Cocoa/Cocoa.h>

/* Bill's states */
typedef NS_ENUM(int, BillState) {
	BILL_STATE_IN = 1,
	BILL_STATE_AT,
	BILL_STATE_OUT,
	BILL_STATE_DYING,
	BILL_STATE_STRAY
};

/* Offsets from upper right of computer */
#define BILL_OFFSET_X 20
#define BILL_OFFSET_Y 3

@interface MBBill : NSObject
{
@public
	BillState state;		/* what is it doing? */
	int index;		/* index of animation frame */
	MBPicture **cels;		/* array of animation frames */
	int x, y;		/* location */
	int target_x;		/* target x position */
	int target_y;		/* target y position */
	int target_c;		/* target computer */
	int cargo;		/* which OS carried */
	int x_offset;		/* accounts for width differences */
	int y_offset;		/* 'bounce' factor for OS carried */
	int sx, sy;		/* used for drawing extra OS during switch */
	MBBill *prev, *next;
}

@property (readonly) BillState state;
@property (readonly) int height;

@property (readonly) int x;
@property (readonly) int y;

+ (void)Bill_class_init:g :h :n :o :u;

+ (instancetype)newBill;
- (void)draw;
- (void)update;
- (void)killBill;
- (BOOL)clickedAtX:(int)locx y:(int)locy;
- (BOOL)clickedStrayAtX:(int)locx y:(int)locy;
+ (void)Bill_load_pix;
+ (int)width;

@end
