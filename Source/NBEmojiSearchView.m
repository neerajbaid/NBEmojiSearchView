#import "NBEmojiManager.h"
#import "NBEmojiSearchResultTableViewCell.h"
#import "NBEmojiSearchView.h"

@interface NBEmojiSearchView () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *dividerView;

@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) NBEmojiManager *manager;
@property (nonatomic) NSRange currentSearchRange;

@end

@implementation NBEmojiSearchView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.tableView];
        [self addSubview:self.dividerView];
        self.rowHeight = 44.0;
        self.alpha = 0.0;
        self.font = [UIFont systemFontOfSize:17.0];
        self.textColor = [UIColor darkTextColor];
    }
    return self;
}

#pragma mark - Public

- (void)searchWithText:(NSString *)searchText
{
    [self.manager searchWithText:searchText];
    if ([self.manager numberOfSearchResults] == 0) {
        [self disappear];
    } else {
        [self.tableView reloadData];
        [self appear];
    }
}

- (void)installOnTextField:(UITextField *)textField
                  delegate:(id)delegate
{
    self.delegate = delegate;
    self.textField = textField;
    self.textField.delegate = self;
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
    [self disappear];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.manager clear];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.rowHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.headerTitle;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.delegate performSelector:@selector(textFieldDidBeginEditing:) withObject:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.delegate performSelector:@selector(textFieldDidEndEditing:) withObject:textField];
    }
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSRange colonRange = [newString rangeOfString:@":"
                                          options:NSBackwardsSearch
                                            range:NSMakeRange(0, range.location + string.length)];
    NSRange spaceRange = [newString rangeOfString:@" "
                                          options:NSBackwardsSearch
                                            range:NSMakeRange(0, range.location + string.length)];
    if (colonRange.location == NSNotFound) {
        [self disappear];
    } else if (spaceRange.location == NSNotFound || colonRange.location > spaceRange.location) {
        NSUInteger searchLength = newString.length - colonRange.location - 1;
        NSRange spaceRange = [newString rangeOfString:@" "
                                              options:NSCaseInsensitiveSearch
                                                range:NSMakeRange(colonRange.location + 1, searchLength)];
        NSString *searchText;
        if (spaceRange.location == NSNotFound) {
            searchText = [newString substringFromIndex:colonRange.location + 1];
        } else {
            searchText = [newString substringWithRange:NSMakeRange(colonRange.location + 1,
                                                                   spaceRange.location - colonRange.location - 1)];
        }
        self.currentSearchRange = NSMakeRange(colonRange.location + 1, searchText.length);
        [self searchWithText:searchText];
    } else {
        [self disappear];
    }
    if ([self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.delegate performSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)
                                   withObject:textField];
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [self.delegate performSelector:@selector(textFieldShouldBeginEditing:) withObject:textField];
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [self.delegate performSelector:@selector(textFieldShouldClear:) withObject:textField];
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [self.delegate performSelector:@selector(textFieldShouldEndEditing:) withObject:textField];
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [self.delegate performSelector:@selector(textFieldShouldReturn:) withObject:textField];
    } else {
        return YES;
    }
}

#pragma mark - View

- (void)appear
{
    self.alpha = 1.0;
}

- (void)disappear
{
    [self.manager clear];
    self.currentSearchRange = NSMakeRange(0, 0);
    self.alpha = 0.0;
}

@end
