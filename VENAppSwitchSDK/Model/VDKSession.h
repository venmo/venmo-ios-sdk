#import <Foundation/Foundation.h>

@interface VDKSession : NSObject

@property (strong, nonatomic, readonly) NSString *accessToken;
@property (strong, nonatomic, readonly) NSString *refreshToken;
@property (assign, nonatomic, readonly) NSInteger expiresIn;

/**
 Creates a VDKSession instance with access token, refresh token, and time til expiration.
 @param accessToken Access token
 @param refreshToken Refresh token
 @param expiresIn Time (seconds) til session expiration
 @return The initialized session
 */
- (instancetype)initWithAccessToken:(NSString *)accessToken
                       refreshToken:(NSString *)refreshToken
                          expiresIn:(NSInteger)expiresIn;

@end
