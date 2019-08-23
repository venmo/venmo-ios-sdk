#import "NSString+VenmoSDK.h"

@implementation NSString (VenmoSDK)

- (NSString *)formURLDecodedString {
    NSString *deplussed = [self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    return [deplussed stringByRemovingPercentEncoding];
}

@end
