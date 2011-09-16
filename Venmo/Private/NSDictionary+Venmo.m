#import "NSDictionary+Venmo.h"
#import "NSString+Venmo.h"

@implementation NSDictionary (Venmo)

+ (NSMutableDictionary *)dictionaryWithFormEncodedString:(NSString *)encodedString {
	NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSCharacterSet *separators = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
	NSArray *pairs = [encodedString componentsSeparatedByCharactersInSet:separators];

	for (NSString *keyValueString in pairs) {
		if ([keyValueString length] == 0) continue;
        NSArray *keyValueArray = [keyValueString componentsSeparatedByString:@"="];
        NSString *key = [[keyValueArray objectAtIndex:0] stringByUnescapingFromURLQuery];
        NSString *value = [keyValueArray count] > 1 ?
        [[keyValueArray objectAtIndex:1] stringByUnescapingFromURLQuery] : @"";
        [params setObject:value forKey:key];
//        // The below is technically correct, but the line above is simpler (and like Rack).
//        NSMutableArray *values = [params objectForKey:key];
//        values ? [values addObject:value] :
//        [params setObject:[NSMutableArray arrayWithObject:value] forKey:key];
	}
	return params;
}

- (id)objectOrNilForKey:(id)key {
    id object = [self objectForKey:key];
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

- (NSUInteger)unsignedIntegerForKey:(id)aKey {
    NSNumber *number = (NSNumber *)[self objectForKey:aKey];
    if ([number respondsToSelector:@selector(unsignedIntegerValue)]) {
        return [number unsignedIntegerValue];
    } else {
        return 0;
    }
}

- (NSString *)stringForKey:(id)key {
    id object = [self objectForKey:key];
    return [object respondsToSelector:@selector(stringValue)] ? [object stringValue] : nil;
}

@end
