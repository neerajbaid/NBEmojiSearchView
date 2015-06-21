#import <UIKit/UIKit.h>

#import "NBEmoji.h"

@interface NBEmojiSearchView : UIView

@property (nonatomic) CGFloat rowHeight;
@property (nonatomic, strong) NSString *headerTitle;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UITableView *tableView;

- (void)searchWithText:(NSString *)searchText;
- (void)installOnTextField:(UITextField *)textField;

@end
