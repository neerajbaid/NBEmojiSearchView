#import <UIKit/UIKit.h>

#import "NBEmoji.h"

@interface NBEmojiSearchView : UIView

@property (nonatomic) CGFloat rowHeight;
@property (nonatomic, strong) NSString *headerTitle;

- (void)searchWithText:(NSString *)searchText;
- (void)installOnTextField:(UITextField *)textField
                  delegate:(id)delegate;

@end
