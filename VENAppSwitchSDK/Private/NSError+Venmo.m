#import "NSError+Venmo.h"

@implementation NSError (Venmo)

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code
          description:(NSString *)description recoverySuggestion:(NSString *)recoverySuggestion {
    NSDictionary *errorUserInfo =
    @{NSLocalizedDescriptionKey: NSLocalizedString(description, nil),
     NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(recoverySuggestion, nil)};

    return [NSError errorWithDomain:domain code:code userInfo:errorUserInfo];
}

@end
