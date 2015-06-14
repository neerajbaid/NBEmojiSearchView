#import "NBEmoji.h"
#import "NBEmojiSearchResultTableViewCell.h"

@implementation NBEmojiSearchResultTableViewCell

- (void)awakeFromNib
{
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)setEmoji:(NBEmoji *)emoji
{
    self.textLabel.text = [emoji description];
}

@end
