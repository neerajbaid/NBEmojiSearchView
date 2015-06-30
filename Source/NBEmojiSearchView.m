#import "NBEmojiManager.h"
#import "NBEmojiSearchResultTableViewCell.h"
#import "NBEmojiSearchView.h"

@interface NBEmojiSearchView () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) id<UITextViewDelegate> textViewDelegate;

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) id<UITextFieldDelegate> textFieldDelegate;
@property (nonatomic, strong) UIView *dividerView;

@property (nonatomic, strong) NBEmojiManager *manager;
@property (nonatomic) NSRange currentSearchRange;

@end

@implementation NBEmojiSearchView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.alpha = 0.0;
        self.font = [UIFont systemFontOfSize:17.0];
        self.textColor = [UIColor darkTextColor];
        [self addSubview:self.tableView];
        [self addSubview:self.dividerView];
    }
    return self;
}

#pragma mark - Public

- (void)searchWithText:(NSString *)searchText
{
    [self.manager searchWithText:searchText];
    if ([self.manager numberOfSearchResults]) {
        [self.tableView reloadData];
        [self appear];
    } else {
        [self disappear];
    }
}

- (void)installOnTextField:(UITextField *)textField
{
    self.textView = nil;
    self.textViewDelegate = nil;
    self.textFieldDelegate = textField.delegate;
    self.textField = textField;
    self.textField.delegate = self;
}

- (void)installOnTextView:(UITextView *)textView
{
    self.textField = nil;
    self.textFieldDelegate = nil;
    self.textViewDelegate = textView.delegate;
    self.textView = textView;
    self.textView.delegate = self;
}

#pragma mark - Property

- (NBEmojiManager *)manager
{
    if (!_manager) {
        _manager = [[NBEmojiManager alloc] init];
    }
    return _manager;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.frame = self.bounds;
        _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                       UIViewAutoresizingFlexibleHeight);
        [_tableView registerClass:[NBEmojiSearchResultTableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([NBEmojiSearchResultTableViewCell class])];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = 44.0;
    }
    return _tableView;
}

- (UIView *)dividerView
{
    if (!_dividerView) {
        _dividerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.5)];
        _dividerView.backgroundColor = [UIColor colorWithWhite:205.0/255.0 alpha:1.0];
        _dividerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _dividerView;
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    [self.tableView reloadData];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [self.tableView reloadData];
}

- (void)setHeaderTitle:(NSString *)headerTitle
{
    _headerTitle = headerTitle;
    [self.tableView reloadData];
}

#pragma mark - Appearance/Disappearance

- (void)appear
{
    if ([self.delegate respondsToSelector:@selector(emojiSearchViewWillAppear:)]) {
        [self.delegate emojiSearchViewWillAppear:self];
    }
    if (self.appearAnimationBlock) {
        self.appearAnimationBlock();
    } else {
        self.alpha = 1.0;
        [self appearAnimationDidFinish];
    }
}

- (void)appearAnimationDidFinish
{
    if ([self.delegate respondsToSelector:@selector(emojiSearchViewDidAppear:)]) {
        [self.delegate emojiSearchViewDidAppear:self];
    }
}

- (void)disappear
{
    if ([self.delegate respondsToSelector:@selector(emojiSearchViewWillDisappear:)]) {
        [self.delegate emojiSearchViewWillDisappear:self];
    }
    if (self.disappearAnimationBlock) {
        self.disappearAnimationBlock();
    } else {
        self.alpha = 0.0;
        [self disappearAnimationDidFinish];
    }
}

- (void)disappearAnimationDidFinish
{
    if ([self.delegate respondsToSelector:@selector(emojiSearchViewDidDisappear:)]) {
        [self.delegate emojiSearchViewDidDisappear:self];
    }
    [self.manager clear];
    self.currentSearchRange = NSMakeRange(0, 0);
    [self.tableView reloadData];
}

#pragma mark - UITableView(DataSource|Delegate)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.manager numberOfSearchResults];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = NSStringFromClass([NBEmojiSearchResultTableViewCell class]);
    NBEmojiSearchResultTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier
                                                                                  forIndexPath:indexPath];
    cell.emoji = [self.manager emojiAtIndex:indexPath.row];
    cell.textLabel.font = self.font;
    cell.textLabel.textColor = self.textColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *replacementString = [NSString stringWithFormat:@"%@ ", [self.manager emojiAtIndex:indexPath.row].emoji];
    NSRange extendedRange = NSMakeRange(self.currentSearchRange.location - 1, self.currentSearchRange.length + 1);
    self.textField.text = [self.textField.text stringByReplacingCharactersInRange:extendedRange
                                                                       withString:replacementString];
    self.textView.text = [self.textView.text stringByReplacingCharactersInRange:extendedRange
                                                                     withString:replacementString];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self disappear];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.headerTitle;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.textFieldDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.textFieldDelegate textFieldDidBeginEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.textFieldDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.textFieldDelegate textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    [self handleString:textField.text replacementString:string inRange:range];
    if ([self.textFieldDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.textFieldDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.textFieldDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [self.textFieldDelegate textFieldShouldBeginEditing:textField];
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if ([self.textFieldDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [self.textFieldDelegate textFieldShouldClear:textField];
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([self.textFieldDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [self.textFieldDelegate textFieldShouldEndEditing:textField];
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.textFieldDelegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [self.textFieldDelegate textFieldShouldReturn:textField];
    } else {
        return YES;
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(nonnull UITextView *)textView
{
    if ([self.textViewDelegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        return [self.textViewDelegate textViewShouldBeginEditing:textView];
    } else {
        return YES;
    }
}

- (void)textViewDidBeginEditing:(nonnull UITextView *)textView
{
    if ([self.textViewDelegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        [self.textViewDelegate textViewDidBeginEditing:textView];
    }
}

- (BOOL)textViewShouldEndEditing:(nonnull UITextView *)textView
{
    if ([self.textViewDelegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
        return [self.textViewDelegate textViewShouldEndEditing:textView];
    } else {
        return YES;
    }
}

- (void)textViewDidEndEditing:(nonnull UITextView *)textView
{
    if ([self.textViewDelegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [self.textViewDelegate textViewDidEndEditing:textView];
    }
}

- (BOOL)textView:(nonnull UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(nonnull NSString *)text
{
    [self handleString:textView.text replacementString:text inRange:range];
    if ([self.textViewDelegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        return [self.textViewDelegate textView:textView shouldChangeTextInRange:range replacementText:text];
    } else {
        return YES;
    }
}

- (void)textViewDidChange:(nonnull UITextView *)textView
{
    if ([self.textViewDelegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.textViewDelegate textViewDidChange:textView];
    }
}

- (void)textViewDidChangeSelection:(nonnull UITextView *)textView
{
    if ([self.textViewDelegate respondsToSelector:@selector(textViewDidChangeSelection:)]) {
        [self.textViewDelegate textViewDidChangeSelection:textView];
    }
}

- (BOOL)textView:(nonnull UITextView *)textView shouldInteractWithTextAttachment:(nonnull NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
    if ([self.textViewDelegate respondsToSelector:@selector(textView:shouldInteractWithTextAttachment:inRange:)]) {
        return [self.textViewDelegate textView:textView shouldInteractWithTextAttachment:textAttachment inRange:characterRange];
    } else {
        return YES;
    }
}

- (BOOL)textView:(nonnull UITextView *)textView shouldInteractWithURL:(nonnull NSURL *)URL inRange:(NSRange)characterRange
{
    if ([self.textViewDelegate respondsToSelector:@selector(textView:shouldInteractWithURL:inRange:)]) {
        return [self.textViewDelegate textView:textView shouldInteractWithURL:URL inRange:characterRange];
    } else {
        return YES;
    }
}

#pragma mark - Helpers

- (void)handleString:(NSString *)string replacementString:(NSString *)replacementString inRange:(NSRange)range
{
    NSString *newString = [string stringByReplacingCharactersInRange:range withString:replacementString];
    NSInteger searchLength = range.location + replacementString.length;
    NSRange colonRange = [newString rangeOfString:@":" options:NSBackwardsSearch range:NSMakeRange(0, searchLength)];
    NSRange spaceRange = [newString rangeOfString:@" " options:NSBackwardsSearch range:NSMakeRange(0, searchLength)];
    if (colonRange.location != NSNotFound && (spaceRange.location == NSNotFound || colonRange.location > spaceRange.location)) {
        [self searchWithColonLocation:colonRange.location string:newString];
    } else {
        [self disappear];
    }
}

- (void)searchWithColonLocation:(NSUInteger)colonLocation string:(NSString *)string
{
    NSRange searchRange = NSMakeRange(colonLocation + 1, string.length - colonLocation - 1);
    NSRange spaceRange = [string rangeOfString:@" " options:NSCaseInsensitiveSearch range:searchRange];
    NSString *searchText;
    if (spaceRange.location == NSNotFound) {
        searchText = [string substringFromIndex:colonLocation + 1];
    } else {
        searchText = [string substringWithRange:NSMakeRange(colonLocation + 1, spaceRange.location - colonLocation - 1)];
    }
    self.currentSearchRange = NSMakeRange(colonLocation + 1, searchText.length);
    [self searchWithText:searchText];
}

@end
