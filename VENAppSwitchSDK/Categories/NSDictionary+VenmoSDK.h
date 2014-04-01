#import <Foundation/Foundation.h>

@interface NSDictionary (VenmoSDK)

+ (NSMutableDictionary *)dictionaryWithFormURLEncodedString:(NSString *)encodedString;

- (id)objectOrNilForKey:(id)key;
- (BOOL)boolForKey:(id)key;
- (NSString *)stringForKey:(id)key;

@end
