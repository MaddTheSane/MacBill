/* MBSpark */

#import <Cocoa/Cocoa.h>

#define SPARK_SPEED 4
#define SPARK_DELAY(level) (MAX(20 - (level), 0))

@class MBUI;

@interface MBSpark : NSObject
{
    IBOutlet MBUI *ui;
}

- (void)loadPictures;
@property (readonly) int width;
@property (readonly) int height;
- (void)drawAtX:(int)x y:(int)y index:(int)index;

@end
