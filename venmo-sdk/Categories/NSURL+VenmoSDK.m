#import "NSDictionary+VenmoSDK.h"
#import "NSURL+VenmoSDK.h"

@implementation NSURL (VenmoSDK)

- (NSDictionary *)queryDictionary {
    return [NSDictionary dictionaryWithFormURLEncodedString:[self query]];
}

+ (NSURL *)venmoAppURLWithPath:(NSString *)path {
    return [[NSURL alloc] initWithString:[NSString stringWithFormat:@"venmosdk://venmo.com%@", path]];
}

@end
