#import <UIKit/UIKit.h>

#import "NBEmoji.h"

@class NBEmojiSearchView;

@protocol NBEmojiSearchViewDelegate <NSObject>

@optional

- (void)emojiSearchViewWillAppear:(NBEmojiSearchView *)emojiSearchView;
- (void)emojiSearchViewDidAppear:(NBEmojiSearchView *)emojiSearchView;
- (void)emojiSearchViewWillDisappear:(NBEmojiSearchView *)emojiSearchView;
- (void)emojiSearchViewDidDisappear:(NBEmojiSearchView *)emojiSearchView;

@end

@interface NBEmojiSearchView : UIView

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) id<NBEmojiSearchViewDelegate> delegate;

@property (nonatomic) CGFloat rowHeight;
@property (nonatomic, strong) NSString *headerTitle;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;

- (void)searchWithText:(NSString *)searchText;
- (void)installOnTextField:(UITextField *)textField;

@end
