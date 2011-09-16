#import "NSError+Venmo.h"

@implementation NSError (Venmo)

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code
          description:(NSString *)description recoverySuggestion:(NSString *)recoverySuggestion {
    NSDictionary *errorUserInfo =
    [NSDictionary dictionaryWithObjectsAndKeys:
     NSLocalizedString(description, nil), NSLocalizedDescriptionKey,
     NSLocalizedString(recoverySuggestion, nil), NSLocalizedRecoverySuggestionErrorKey, nil];

    return [NSError errorWithDomain:domain code:code userInfo:errorUserInfo];
}

@end
