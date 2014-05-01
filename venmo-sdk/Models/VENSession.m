#import "VENSession.h"

#import <SSKeychain/SSKeychainQuery.h>
#import <VENCore/VENCore.h>

NSString *const kVENKeychainServiceName = @"venmo-ios-sdk";
NSString *const kVENKeychainAccountNamePrefix = @"venmo";

@interface VENSession ()

@property (strong, nonatomic, readwrite) NSString *accessToken;
@property (strong, nonatomic, readwrite) NSString *refreshToken;
@property (strong, nonatomic, readwrite) NSDate *expirationDate;
@property (strong, nonatomic, readwrite) VENUser *user;
@property (assign, nonatomic, readwrite) VENSessionState state;

@end

@implementation VENSession

- (id)init {
    self = [super init];
    if (self) {
        self.state = VENSessionStateClosed;
    }
    return self;
}


- (void)openWithAccessToken:(NSString *)accessToken
               refreshToken:(NSString *)refreshToken
                  expiresIn:(NSUInteger)expiresIn
                       user:(VENUser *)user {
    self.accessToken = accessToken;
    self.refreshToken = refreshToken;
    self.expirationDate = [NSDate dateWithTimeIntervalSinceNow:expiresIn];
    self.state = VENSessionStateOpen;
    self.user = user;

    // Set default core to an instance with this access token.
    VENCore *core = [[VENCore alloc] init];
    [core setAccessToken:accessToken];
    [VENCore setDefaultCore:core];
}


- (void)close {
    self.accessToken = nil;
    self.refreshToken = nil;
    self.expirationDate = nil;
    self.user = nil;
    self.state = VENSessionStateClosed;
}


- (BOOL)saveWithAppId:(NSString *)appId {
    SSKeychainQuery *query = [VENSession keychainQueryWithAppId:appId];
    query.passwordObject = self;
    NSError *error;
    BOOL saved = [query save:&error];
    return saved;
}


+ (instancetype)cachedSessionWithAppId:(NSString *)appId {
    SSKeychainQuery *query = [VENSession keychainQueryWithAppId:appId];
    NSError *error;
    [query fetch:&error];
    if (!error) {
        return (VENSession *)query.passwordObject;
    }
    return nil;
}


+ (BOOL)deleteSessionWithAppId:(NSString *)appId {
    SSKeychainQuery *query = [VENSession keychainQueryWithAppId:appId];
    NSError *error;
    return [query deleteItem:&error];
}


+ (SSKeychainQuery *)keychainQueryWithAppId:(NSString *)appId {
    SSKeychainQuery *query = [[SSKeychainQuery alloc] init];
    query.service = kVENKeychainServiceName;
    query.account = [NSString stringWithFormat:@"%@%@", kVENKeychainAccountNamePrefix, appId];
    return query;
}


#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.accessToken = [decoder decodeObjectForKey:@"accessToken"];
        self.refreshToken = [decoder decodeObjectForKey:@"refreshToken"];
        self.expirationDate = [decoder decodeObjectForKey:@"expirationDate"];
        self.user = [decoder decodeObjectForKey:@"user"];
        self.state = [decoder decodeIntegerForKey:@"state"];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.accessToken forKey:@"accessToken"];
    [coder encodeObject:self.refreshToken forKey:@"refreshToken"];
    [coder encodeObject:self.expirationDate forKey:@"expirationDate"];
    [coder encodeObject:self.user forKey:@"user"];
    [coder encodeInteger:self.state forKey:@"state"];
}

@end
