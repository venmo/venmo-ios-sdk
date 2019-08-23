#import "NSDictionary+VenmoSDK.h"
#import "NSURL+VenmoSDK.h"

@implementation NSURL (VenmoSDK)

- (NSDictionary *)queryDictionary {
    return [NSDictionary dictionaryWithFormURLEncodedString:[self query]];
}

+ (NSURL *)venmoAppURLWithPath:(NSString *)path {
    NSString *newPath = [NSString stringWithFormat:@"venmosdk://venmo.com%@", path];
    return [[NSURL alloc] initWithString:[newPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
}

@end
