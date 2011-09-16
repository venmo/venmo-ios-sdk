#import "NSString+Venmo.h"

@implementation NSString (Venmo)

- (NSString *)stringValue {
    return self;
}

- (NSUInteger)unsignedIntegerValue {
    return (NSUInteger)[self integerValue];
}

- (NSString *)stringByUnescapingFromURLQuery {
	NSString *deplussed = [self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    return [deplussed stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
