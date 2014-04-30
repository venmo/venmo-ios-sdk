#import "VENSession.h"

@import Security;

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

+ (instancetype)cachedSessionForAppId:(NSString *)appId {
    return nil;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.accessToken = [decoder decodeObjectForKey:@"accessToken"];
        self.refreshToken = [decoder decodeObjectForKey:@"refreshToken"];
        self.expirationDate = [decoder decodeObjectForKey:@"expirationDate"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.accessToken forKey:@"accessToken"];
    [coder encodeObject:self.refreshToken forKey:@"refreshToken"];
    [coder encodeObject:self.expirationDate forKey:@"expirationDate"];
}

@end
