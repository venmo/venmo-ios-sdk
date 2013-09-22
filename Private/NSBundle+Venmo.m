#import "NSBundle+Venmo.h"

@implementation NSBundle (Venmo)

- (NSString *)name {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
}

@end
