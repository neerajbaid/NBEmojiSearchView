#import <Foundation/Foundation.h>

@interface NBEmoji : NSObject

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *emoji;

- (instancetype)initWithName:(NSString *)name
                       emoji:(NSString *)emoji;

@end
