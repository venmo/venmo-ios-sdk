#import "NSBundle+VenmoSDK.h"

@implementation NSBundle (VenmoSDK)

- (NSString *)name {
    return [self objectForInfoDictionaryKey:(NSString *)kCFBundleNameKey];
}

@end
