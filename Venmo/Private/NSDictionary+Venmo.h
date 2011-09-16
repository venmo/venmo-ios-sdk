#import <Foundation/Foundation.h>

@interface NSDictionary (Venmo)

+ (NSMutableDictionary *)dictionaryWithFormEncodedString:(NSString *)encodedString;

- (id)objectOrNilForKey:(id)key;
- (BOOL)boolForKey:(id)key;
- (NSUInteger)unsignedIntegerForKey:(id)aKey;
- (NSString *)stringForKey:(id)key;

@end
