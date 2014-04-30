@import Foundation;

typedef NS_ENUM(NSUInteger, VENSessionState) {
    /// Indicates that the session is closed.
    VENSessionStateClosed,
    /// Indicates that the session is open and ready for use.
    VENSessionStateOpen,
    /// Indicates that an attempt to open the session is underway.
    VENSessionStateOpening,
    /// Indicates that the session is being refreshed.
    VENSessionStateRefreshing
};

@interface VENSession : NSObject <NSCoding>

@property (strong, nonatomic, readonly) NSString *accessToken;
@property (strong, nonatomic, readonly) NSString *refreshToken;
@property (strong, nonatomic, readonly) NSDate *expirationDate;
@property (assign, nonatomic, readonly) VENSessionState state;

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
 * Returns the cached session with the given app id, or nil if no cached session was found.
 */
+ (instancetype)cachedSessionWithAppId:(NSString *)appId;


/**
 * Saves the session in the keychain with the given app id.
 * @return Returns a Boolean value indicating whether or not the save succeeded.
 */
- (BOOL)saveWithAppId:(NSString *)appId;


/**
 * Deletes the session with the given app id.
 * @return Returns a Boolean value indicating whether or not the save succeeded.
 */
+ (BOOL)deleteSessionWithAppId:(NSString *)appId;

@end
