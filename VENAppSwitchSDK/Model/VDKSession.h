#import <Foundation/Foundation.h>

@interface VDKSession : NSObject

@property (strong, nonatomic, readonly) NSString *accessToken;
@property (strong, nonatomic, readonly) NSString *refreshToken;
@property (assign, nonatomic) NSInteger expiresIn;

- (id)initWithAccessToken:(NSString *)accessToken
             refreshToken:(NSString *)refreshToken
                expiresIn:(NSInteger)expiresIn;

@end
