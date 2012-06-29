#import "NSDictionary+Venmo.h"
#import "NSURL+Venmo.h"

@implementation NSURL (Venmo)

// Ref: https://github.com/samsoffes/sstoolkit/blob/master/SSToolkit/NSURL+SSToolkitAdditions.m
- (NSDictionary *)queryDictionary {
    return [NSDictionary dictionaryWithFormURLEncodedString:[self query]];
}

@end
