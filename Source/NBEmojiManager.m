#import "NBEmoji.h"
#import "NBEmojiManager.h"

@interface NBEmojiManager ()

@property (nonatomic, strong) NSArray *allEmoji;
@property (nonatomic, strong) NSArray *searchedEmoji;
@property (nonatomic, strong) NSArray *topEmoji;

@end

@implementation NBEmojiManager

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadEmoji];
    }
    return self;
}

- (NSArray *)allEmoji
{
    if (!_allEmoji) {
        _allEmoji = [NSArray array];
    }
    return _allEmoji;
}

- (NSArray *)topEmoji
{
    if (!_topEmoji) {
        _topEmoji = [NSArray array];
    }
    return _topEmoji;
}

- (void)loadEmoji
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[@"AllEmoji" stringByDeletingPathExtension]
                                                         ofType:@"json"];
    NSDictionary *emojiDictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath]
                                                                    options:NSJSONReadingAllowFragments
                                                                      error:nil];
    for (NSString *name in emojiDictionary) {
        self.allEmoji = [self.allEmoji arrayByAddingObject:
                         [[NBEmoji alloc] initWithName:name
                                                 emoji:emojiDictionary[name]]];
    }
    self.allEmoji = [self.allEmoji sortedArrayUsingComparator:^NSComparisonResult(NBEmoji *obj1, NBEmoji *obj2) {
        return [obj1.name compare:obj2.name];
    }];
    for (NSString *name in [self topEmojiList]) {
        self.topEmoji = [self.topEmoji arrayByAddingObject:
                         [[NBEmoji alloc] initWithName:name
                                                 emoji:emojiDictionary[name]]];
    }
}

#pragma mark - Public

- (void)searchWithText:(NSString *)searchText
{
    if (searchText.length == 0) {
        self.searchedEmoji = nil;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NBEmoji *evaluatedObject, NSDictionary *bindings) {
            return ([[evaluatedObject.name lowercaseString] containsString:[searchText lowercaseString]] ||
                    [[evaluatedObject.emoji lowercaseString] containsString:[searchText lowercaseString]]);
        }];
        self.searchedEmoji = [self.allEmoji filteredArrayUsingPredicate:predicate];
    }
}

#pragma mark - Data Source

- (NSInteger)numberOfSearchResults
{
    if (self.searchedEmoji) {
        return [self.searchedEmoji count];
    } else {
        return [self.topEmoji count];
    }
}

- (NBEmoji *)emojiAtIndex:(NSInteger)index
{
    if (self.searchedEmoji) {
        if (index < self.searchedEmoji.count) {
            return self.searchedEmoji[index];
        } else {
            return nil;
        }
    } else {
        if (index < self.topEmoji.count) {
            return self.topEmoji[index];
        } else {
            return nil;
        }
    }
}

- (void)clear
{
    self.searchedEmoji = nil;
}

#pragma mark - Private

- (NSArray *)topEmojiList
{
    return @[@"pizza",
             @"cab",
             @"beers",
             @"wine",
             @"icecream",
             @"confetti",
             @"drumstick",
             @"beer",
             @"ramen",
             @"rooster",
             @"dancers",
             @"cocktail",
             @"football",
             @"fork_and_knife",
             @"basketball",
             @"dancer",
             @"tv",
             @"sushi",
             @"burger"];
}

@end
