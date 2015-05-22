#import "MBtypes.h"
#import "MBScorelist.h"

#import "MBUI.h"

#define NAMELEN 20
#define SCORES 10

#define kHighName @"name"
#define kHighLevel @"level"
#define kHighScore @"score"

@implementation MBScorelist
{
	NSMutableArray *scores;
}

- (void)readScoreList
{
	id tmpArray;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	scores = [[NSMutableArray alloc] init];
	if ((tmpArray = [defaults arrayForKey:@"scores"]) != nil) {
		[scores setArray:tmpArray];
	}
	
	//Fill out any missing values
	NSNumber *zero = @0;
	while (scores.count < SCORES) {
		NSDictionary *dict = @{kHighName: @"Anonymous",
							   kHighLevel: zero,
							   kHighScore: zero};
		[scores addObject:dict];
	}
	
	//Ensure all values are of the proper type
	NSArray *maybeBadScores = [scores copy];
	for (NSInteger i = 0; i < SCORES; i++) {
		NSDictionary *badScore = maybeBadScores[i];
		NSMutableDictionary *goodScore = [badScore mutableCopy];
		goodScore[kHighLevel] = @([badScore[kHighLevel] integerValue]);
		goodScore[kHighScore] = @([badScore[kHighScore] integerValue]);

		scores[i] = goodScore;
		[goodScore release];
	}
	
	[maybeBadScores release];
}

- (void)sortScores
{
	[scores sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		NSDictionary *dict1 = obj1;
		NSDictionary *dict2 = obj2;
		
		NSNumber *score1 = dict1[kHighScore];
		NSNumber *score2 = dict2[kHighScore];
		
		return [score1 compare:score2];
	}];
}

- (void)writeScoreList
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:scores forKey:@"scores"];
	[defaults synchronize];
}

- (void)addScoreWithName:(NSString*)str level:(int)level score:(int)score;
{
	NSDictionary *dict;
	
	if (str == NULL || str.length == 0) {
		str = @"Anonymous";
	}
	
	dict = @{kHighName: str,
			 kHighLevel: @(level),
			 kHighScore: @(score)};
	
	[scores addObject:dict];
	
	[self sortScores];
	
	[scores removeLastObject];
}

- (BOOL)isHighScore:(int)val
{
	return (val > [[[scores objectAtIndex:SCORES - 1] objectForKey:kHighScore] intValue]);
}

- (void)dealloc
{
	[scores release]; scores = nil;
	
	[super dealloc];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return (SCORES);
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	id theRecord, theValue;
	NSParameterAssert(rowIndex >= 0 && rowIndex < SCORES);
	theRecord = [scores objectAtIndex:rowIndex];
	theValue = [theRecord objectForKey:[aTableColumn identifier]];
	return theValue;
}

@end
