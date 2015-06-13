#import "NBEmojiManager.h"
#import "NBEmojiSearchResultTableViewCell.h"
#import "NBEmojiSearchView.h"

@interface NBEmojiSearchView () <UITableViewDataSource, UITableViewDelegate>

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
    }
    return self;
}

#pragma mark - Public

- (void)searchWithText:(NSString *)searchText
{
    [self.manager searchWithText:searchText];
    [self.tableView reloadData];
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
    return [self.manager numberOfSearchResults];
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
    if ([self.delegate respondsToSelector:@selector(emojiSearchView:didSelectEmoji:)]) {
        [self.delegate emojiSearchView:self didSelectEmoji:[self.manager emojiAtIndex:indexPath.row]];
    }
    [self.manager clear];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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

@end
