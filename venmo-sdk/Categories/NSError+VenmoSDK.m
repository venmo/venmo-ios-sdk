#import "NSError+VenmoSDK.h"
#import "VENErrors.h"

@implementation NSError (VenmoSDK)

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code
          description:(NSString *)description recoverySuggestion:(NSString *)recoverySuggestion {
    NSDictionary *errorUserInfo =
    [NSDictionary dictionaryWithObjectsAndKeys:
     NSLocalizedString(description, nil), NSLocalizedDescriptionKey,
     NSLocalizedString(recoverySuggestion, nil), NSLocalizedRecoverySuggestionErrorKey, nil];

    return [NSError errorWithDomain:domain code:code userInfo:errorUserInfo];
}


+ (instancetype)sessionNotOpenError {
    return [NSError errorWithDomain:VenmoSDKDomain
                               code:VENSDKErrorSessionNotOpen
                        description:@"The current session is not open."
                 recoverySuggestion:@"If the session is closed, call requestPermissions:withCompletionHandler: to open a new session"];
}


+ (instancetype)accessTokenExpiredError {
    return [NSError errorWithDomain:VenmoSDKDomain
                               code:VENSDKErrorAccessTokenExpired
                        description:@"The current session's access token has expired"
                 recoverySuggestion:@"Call refreshTokenWithCompletionHandler: to refresh the token"];
}


@end
