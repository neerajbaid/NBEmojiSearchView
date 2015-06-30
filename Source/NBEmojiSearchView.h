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

@property (nonatomic, strong) NSString *headerTitle;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;

// If you choose to customize the emoji view's appear animation, you MUST call
// appearAnimationDidFinish when your animation is complete.
@property (nonatomic, copy) void (^appearAnimationBlock)();
- (void)appearAnimationDidFinish;

// If you choose to customize the emoji view's disappear animation, you MUST call
// disappearAnimationDidFinish when your animation is complete.
@property (nonatomic, copy) void (^disappearAnimationBlock)();
- (void)disappearAnimationDidFinish;

- (void)installOnTextField:(UITextField *)textField;
- (void)installOnTextView:(UITextView *)textView;

@end
