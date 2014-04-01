#import "NSDictionary+VenmoSDK.h"
#import "NSURL+VenmoSDK.h"

@implementation NSURL (VenmoSDK)

// Ref: https://github.com/samsoffes/sstoolkit/blob/master/SSToolkit/NSURL+SSToolkitAdditions.m
- (NSDictionary *)queryDictionary {
    return [NSDictionary dictionaryWithFormURLEncodedString:[self query]];
}

@end
