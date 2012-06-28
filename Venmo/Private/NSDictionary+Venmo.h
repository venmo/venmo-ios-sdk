#import <Foundation/Foundation.h>

@interface NSDictionary (Venmo)

+ (NSMutableDictionary *)dictionaryWithFormEncodedString:(NSString *)encodedString;

- (BOOL)boolForKey:(id)key;

@end
