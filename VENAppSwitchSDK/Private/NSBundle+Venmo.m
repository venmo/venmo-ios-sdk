#import "NSBundle+Venmo.h"

@implementation NSBundle (Venmo)

- (NSString *)name {
    return [self objectForInfoDictionaryKey:(NSString *)kCFBundleNameKey];
}

@end
