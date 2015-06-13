#import <UIKit/UIKit.h>

#import "NBEmoji.h"

@class NBEmojiSearchView;

@protocol NBEmojiSearchViewDelegate <NSObject>

@optional

- (void)emojiSearchView:(NBEmojiSearchView *)emojiSearchView didSelectEmoji:(NBEmoji *)emoji;

@end

@interface NBEmojiSearchView : UIView

@property (nonatomic, strong) id<NBEmojiSearchViewDelegate> delegate;

@property (nonatomic) CGFloat rowHeight;
@property (nonatomic, strong) NSString *headerTitle;

- (void)searchWithText:(NSString *)searchText;

@end
