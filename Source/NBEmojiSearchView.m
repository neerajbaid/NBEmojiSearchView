#import "NBEmojiManager.h"
#import "NBEmojiSearchResultTableViewCell.h"
#import "NBEmojiSearchView.h"

@interface NBEmojiSearchView () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NBEmojiManager *manager;

@end

@implementation NBEmojiSearchView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.tableView];
        self.rowHeight = 44.0;
        self.alpha = 0.0;
    }
    return self;
}

#pragma mark - Public

- (void)searchWithText:(NSString *)searchText
{
    [self.manager searchWithText:searchText];
    [self.tableView reloadData];
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

#pragma mark - UITableView(DataSource|Delegate)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = [self.manager numberOfSearchResults];
    if (numberOfRows == 0) {
        [self disappear];
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = NSStringFromClass([NBEmojiSearchResultTableViewCell class]);
    NBEmojiSearchResultTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier
                                                                                  forIndexPath:indexPath];
    cell.emoji = [self.manager emojiAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self disappear];
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
    if ([string isEqualToString:@" "] ||
        newString.length == 0) {
        [self disappear];
    } else if ([string isEqualToString:@":"]) {
        if (newString.length == 1) {
            [self appear];
        } else if (newString.length > 1 &&
                   [[newString substringWithRange:NSMakeRange(range.location - 1, 1)] isEqualToString:@" "]) {
            [self appear];
        }
    } else {
        NSString *beforeString = [newString substringToIndex:range.location];
        for (NSInteger i = beforeString.length - 1; i >= 0; i--) {
            NSString *character = [beforeString substringWithRange:NSMakeRange(i, 1)];
            if ([character isEqualToString:@" "]) {
                [self disappear];
                break;
            } else if ([character isEqualToString:@":"]) {
                NSInteger startingIndex = i + 1;
                NSUInteger length = 0;
                for (NSInteger j = startingIndex; j < newString.length; j++) {
                    character = [newString substringWithRange:NSMakeRange(j, 1)];
                    if ([character isEqualToString:@" "]) {
                        break;
                    }
                    length++;
                }
                NSString *searchText = [newString substringWithRange:NSMakeRange(startingIndex, length)];
                [self searchWithText:searchText];
                [self appear];
                break;
            }
        }
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
    self.alpha = 0.0;
}

@end
