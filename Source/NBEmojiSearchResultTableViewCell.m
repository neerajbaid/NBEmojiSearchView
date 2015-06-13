#import "NBEmoji.h"
#import "NBEmojiSearchResultTableViewCell.h"

@implementation NBEmojiSearchResultTableViewCell

- (void)setEmoji:(NBEmoji *)emoji
{
    self.textLabel.text = [emoji description];
}

@end
