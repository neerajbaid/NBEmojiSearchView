#import <Foundation/Foundation.h>

@class NBEmoji;

@interface NBEmojiManager : NSObject

- (void)searchWithText:(NSString *)searchText;
- (NSInteger)numberOfSearchResults;
- (NBEmoji *)emojiAtIndex:(NSInteger)index;
- (void)clear;

@end
