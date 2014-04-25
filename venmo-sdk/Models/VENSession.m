#import "VENSession.h"

@interface VENSession ()
@property (strong, nonatomic, readwrite) NSString *accessToken;
@property (strong, nonatomic, readwrite) NSString *refreshToken;
@property (assign, nonatomic, readwrite) NSUInteger expiresIn;
@end

@implementation VENSession

- (id)initWithAccessToken:(NSString *)accessToken
             refreshToken:(NSString *)refreshToken
                expiresIn:(NSUInteger)expiresIn {
    self = [super init];
    if (self) {
        self.accessToken = accessToken;
        self.refreshToken = refreshToken;
        self.expiresIn = expiresIn;
    }
    return self;
}

@end
