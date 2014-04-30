#import <Foundation/Foundation.h>

@interface NSURL (VenmoSDK)

- (NSDictionary *)queryDictionary;

/**
 * Returns a venmo app switch url with the given path.
 */
+ (NSURL *)venmoAppURLWithPath:(NSString *)path;

@end
