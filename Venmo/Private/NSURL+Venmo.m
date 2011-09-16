#import "NSDictionary+Venmo.h"
#import "NSURL+Venmo.h"

@implementation NSURL (Venmo)

// Source: https://github.com/samsoffes/sstoolkit/blob/master/SSToolkit/NSURL+SSToolkitAdditions.m
- (NSDictionary *)queryDictionary {
    return [NSDictionary dictionaryWithFormEncodedString:self.query];
}

@end
