#import <Foundation/Foundation.h>

@interface VDKSession : NSObject
//TODO: make readonly if necessary
@property (nonatomic, strong, readonly) NSString *accessToken;
@property (nonatomic, strong, readonly) NSString *refreshToken;
@property (nonatomic) NSInteger expiresIn;

- (id)initWithAccessToken:(NSString *)accessToken
             refreshToken:(NSString *)refreshToken
                expiresIn:(NSInteger)expiresIn;

@end
