#import "NBEmoji.h"

@interface NBEmoji ()

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *emoji;

@end

@implementation NBEmoji

- (instancetype)initWithName:(NSString *)name
                       emoji:(NSString *)emoji
{
    self = [super init];
    if (self) {
        self.name = name;
        self.emoji = emoji;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@  %@", self.emoji, self.name];
}

@end
