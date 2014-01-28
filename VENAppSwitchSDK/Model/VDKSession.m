#import "VDKSession.h"

@interface VDKSession ()
@property (strong, nonatomic, readwrite) NSString *accessToken;
@property (strong, nonatomic, readwrite) NSString *refreshToken;
@end

@implementation VDKSession

- (id)initWithAccessToken:(NSString *)accessToken
             refreshToken:(NSString *)refreshToken
                expiresIn:(NSInteger)expiresIn {
    self = [super init];
    if (self) {
        self.accessToken = accessToken;
        self.refreshToken = refreshToken;
        self.expiresIn = expiresIn;
    }
    return self;
}

@end
