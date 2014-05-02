@import Foundation;

#import "Venmo.h"
#import "VENUser+VenmoSDK.h"

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

typedef void (^VENRefreshTokenCompletionHandler)(NSString *accessToken, BOOL success, NSError *error);

@interface VENSession : NSObject <NSCoding>

@property (strong, nonatomic, readonly) NSString *accessToken;
@property (strong, nonatomic, readonly) NSString *refreshToken;
@property (strong, nonatomic, readonly) NSDate *expirationDate;
@property (strong, nonatomic, readonly) VENUser *user;
@property (assign, nonatomic, readonly) VENSessionState state;

/**
 * Opens the session with an access token, refresh token, time until expiration, and a user.
 * @param accessToken Access token
 * @param refreshToken Refresh token
 * @param expiresIn Time (seconds) until the token expires
 * @param user The user associated with the token
 * @return The initialized session
 */
- (void)openWithAccessToken:(NSString *)accessToken
               refreshToken:(NSString *)refreshToken
                  expiresIn:(NSUInteger)expiresIn
                       user:(VENUser *)user;


/**
 * Refreshes the session's access token.
 * @param appId The app ID associated with the session
 * @param appSecret The app secret associated with the session
 * @param completionHandler The handler block to execute
 */
- (void)refreshTokenWithAppId:(NSString *)appId
                       secret:(NSString *)appSecret
            completionHandler:(VENRefreshTokenCompletionHandler)completionHandler;


/**
 * Closes the session.
 */
- (void)close;


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
