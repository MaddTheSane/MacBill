/* MBScorelist */

#import <Cocoa/Cocoa.h>

@class MBUI;

@interface MBScorelist : NSObject <NSTableViewDataSource>
{
    IBOutlet MBUI *ui;
}

- (void)readScoreList;
- (void)writeScoreList;
/*!
 *  Add new high score to list
 */
- (void)addScoreWithName:(NSString*)str level:(int)level score:(int)score;
- (BOOL)isHighScore:(int)val;

@end
