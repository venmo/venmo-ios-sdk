#import "NSDictionary+Venmo.h"
#import "NSString+Venmo.h"

@implementation NSDictionary (Venmo)

+ (NSMutableDictionary *)dictionaryWithFormURLEncodedString:(NSString *)URLEncodedString {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSCharacterSet *separators = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSArray *pairs = [URLEncodedString componentsSeparatedByCharactersInSet:separators];

    for (NSString *keyValueString in pairs) {
        if ([keyValueString length] == 0) continue;
        NSArray *keyValueArray = [keyValueString componentsSeparatedByString:@"="];
        NSString *key = [[keyValueArray objectAtIndex:0] formURLDecodedString];
        NSString *value = ([keyValueArray count] > 1 ?
                           [[keyValueArray objectAtIndex:1] formURLDecodedString] : @"");
        [params setObject:value forKey:key];
    }
    return params;
}

- (BOOL)boolForKey:(id)key {
    id object = [self objectForKey:key];
    if ([object respondsToSelector:@selector(boolValue)]) {
        return [object boolValue];
    } else {
        return object != nil && object != [NSNull null];
    }
}

@end
