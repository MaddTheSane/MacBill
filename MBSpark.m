#import "MBtypes.h"
#import "MBSpark.h"

#import "MButil.h"

#import "MBUI.h"

static MBPicture *pictures[2];

@implementation MBSpark

- (void)Spark_load_pix
{
	int i;
	for (i = 0; i < 2; i++)
		[ui loadImageNamed:@"spark" atIndex:i hasTransparency:YES outPicture:&pictures[i]];
}

- (int)width
{
	return [ui UI_picture_width:pictures[0]];
}

- (int)height
{
	return [ui UI_picture_height:pictures[0]];
}

- (void)drawAtX:(int)x y:(int)y index:(int)index
{
	[ui drawPicture:pictures[index] atX:x y:y];
}

@end
