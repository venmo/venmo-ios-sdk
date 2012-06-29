#import <Foundation/Foundation.h>

@interface NSDictionary (Venmo)

+ (NSMutableDictionary *)dictionaryWithFormURLEncodedString:(NSString *)encodedString;

- (BOOL)boolForKey:(id)key;

@end
