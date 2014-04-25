#import "NSDictionary+VenmoSDK.h"
#import "NSString+VenmoSDK.h"

@implementation NSDictionary (VenmoSDK)

+ (NSMutableDictionary *)dictionaryWithFormURLEncodedString:(NSString *)URLEncodedString {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSCharacterSet *separators = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSArray *pairs = [URLEncodedString componentsSeparatedByCharactersInSet:separators];

    for (NSString *keyValueString in pairs) {
        if ([keyValueString length] == 0) continue;
        NSArray *keyValueArray = [keyValueString componentsSeparatedByString:@"="];
        NSString *key = [keyValueArray[0] formURLDecodedString];
        NSString *value = ([keyValueArray count] > 1 ?
                           [keyValueArray[1] formURLDecodedString] : @"");
        params[key] = value;
    }
    return params;
}

- (id)objectOrNilForKey:(id)key {
    id object = self[key];
    return object == [NSNull null] ? nil : object;
}

- (BOOL)boolForKey:(id)key {
    id object = [self objectOrNilForKey:key];
    if ([object respondsToSelector:@selector(boolValue)]) {
        return [object boolValue];
    } else {
        return object != nil;
    }
}

- (NSString *)stringForKey:(id)key {
    id object = [self objectOrNilForKey:key];
    return [object respondsToSelector:@selector(stringValue)] ? [object stringValue] : object;
}

@end
