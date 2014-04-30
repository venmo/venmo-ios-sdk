@import Foundation;

@interface VENSession : NSObject <NSCoding>

@property (strong, nonatomic, readonly) NSString *accessToken;
@property (strong, nonatomic, readonly) NSString *refreshToken;
@property (strong, nonatomic, readonly) NSDate *expirationDate;

/**
 * Creates a VENSession instance with access token, refresh token, and time until expiration.
 * @param accessToken Access token
 * @param refreshToken Refresh token
 * @param expiresIn Time (seconds) til session expiration
 * @return The initialized session
 */
- (instancetype)initWithAccessToken:(NSString *)accessToken
                       refreshToken:(NSString *)refreshToken
                          expiresIn:(NSUInteger)expiresIn;

/**
 * Returns the cached session for the given app id, or nil if no cached session was found.
 */
+ (instancetype)cachedSessionForAppId:(NSString *)appId;

@end
