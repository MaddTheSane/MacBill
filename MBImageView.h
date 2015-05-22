/* MBImageView */

#import <Cocoa/Cocoa.h>

@class MBAqua;

@interface MBImageView : NSImageView
{
    IBOutlet MBAqua *aqua;
	NSImage *subimage;
	NSPoint cursor;
	BOOL drawCursor;
}

- (void)setSubimage:(NSImage *)image;
- (void)drawCursor:(BOOL)flag;
- (void)setTransparency:(int)trans;

@end
