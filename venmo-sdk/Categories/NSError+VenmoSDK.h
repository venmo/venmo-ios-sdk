#import <Foundation/Foundation.h>

@interface NSError (VenmoSDK)

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code
          description:(NSString *)description recoverySuggestion:(NSString *)recoverySuggestion;


/**
 * Returns an error indicating that the session is closed.
 */
+ (instancetype)sessionNotOpenError;


/**
 * Returns an error indicating that the session's access token has expired.
 */
+ (instancetype)accessTokenExpiredError;

@end
