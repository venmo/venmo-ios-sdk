#import "NSString+Venmo.h"

@implementation NSString (Venmo)

- (NSString *)formURLDecodedString {
    NSString *deplussed = [self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    return [deplussed stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
