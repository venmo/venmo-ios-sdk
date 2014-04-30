#import "VENSession.h"

@interface VENSession ()
@property (strong, nonatomic, readwrite) NSString *accessToken;
@property (strong, nonatomic, readwrite) NSString *refreshToken;
@property (strong, nonatomic, readwrite) NSDate *expirationDate;
@end

@implementation VENSession

- (id)initWithAccessToken:(NSString *)accessToken
             refreshToken:(NSString *)refreshToken
                expiresIn:(NSUInteger)expiresIn {
    self = [super init];
    if (self) {
        self.accessToken = accessToken;
        self.refreshToken = refreshToken;
        self.expirationDate = [NSDate dateWithTimeIntervalSinceNow:expiresIn];
    }
    return self;
}

@end
