#import "NSString+Venmo.h"

@implementation NSString (Venmo)

- (NSString *)stringByUnescapingFromURLQuery {
    NSString *deplussed = [self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    return [deplussed stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
