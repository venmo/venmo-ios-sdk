#import "VENSession.h"
#import "VENKeychain.h"

#import <VENCore/VENCore.h>

NSString *const kVENKeychainServiceName = @"venmo-ios-sdk";
NSString *const kVENKeychainAccountNamePrefix = @"venmo";

@interface Venmo ()

- (NSString *)baseURLPath;

@end

@interface VENSession ()

@property (strong, nonatomic, readwrite) NSString *accessToken;
@property (strong, nonatomic, readwrite) NSString *refreshToken;
@property (strong, nonatomic, readwrite) NSDate *expirationDate;
@property (strong, nonatomic, readwrite) VENUser *user;
@property (assign, nonatomic, readwrite) VENSessionState state;
@property (strong, nonatomic) VENKeychain *keychain;

@end

@implementation VENSession

- (id)init {
    self = [super init];
    if (self) {
        self.state = VENSessionStateClosed;
        self.keychain = [[VENKeychain alloc] initWithService:kVENKeychainServiceName];
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


- (void)refreshTokenWithAppId:(NSString *)appId
                       secret:(NSString *)appSecret
            completionHandler:(VENRefreshTokenCompletionHandler)completionHandler {
    // configure the url
    Venmo *venmo = [Venmo sharedInstance];
    NSString *baseURL = venmo ? [venmo baseURLPath] : @"http://api.venmo.com/v1";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/access_token", baseURL]];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setTimeoutInterval:10];
    [request setHTTPMethod:@"POST"];

    // add parameters
    NSDictionary *parameters = @{@"client_id": appId,
                                 @"client_secret": appSecret,
                                 @"refresh_token": self.refreshToken};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    [request setHTTPBody:jsonData];

    VENSessionState originalState = self.state;
    self.state = VENSessionStateRefreshing;

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSDictionary *json = nil;
                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                               if (connectionError ||
                                   (httpResponse && httpResponse.statusCode > 299)) {
                                   NSError *error = [NSError errorWithDomain:VenmoSDKDomain
                                                                        code:VENSDKErrorHTTPError
                                                                    userInfo:nil];
                                   self.state = originalState;
                                   if (completionHandler) {
                                       completionHandler(nil, NO, error);
                                   }
                                   return;
                               }
                               NSError *error = nil;
                               json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                               if (error) {
                                   NSError *error = [NSError errorWithDomain:VenmoSDKDomain
                                                                        code:VENSDKErrorSystemApi
                                                                    userInfo:nil];
                                   self.state = originalState;
                                   if (completionHandler) {
                                       completionHandler(nil, NO, error);
                                   }
                                   return;
                               }
                               NSString *accessToken = json[@"access_token"];
                               NSString *refreshToken = json[@"refresh_token"];
                               NSUInteger expiresIn = [json[@"expires_in"] integerValue];

                               // Update and save
                               self.accessToken = accessToken;
                               self.refreshToken = refreshToken;
                               self.expirationDate = [NSDate dateWithTimeIntervalSinceNow:expiresIn];
                               self.state = VENSessionStateOpen;
                               [self saveWithAppId:appId];

                               // Set default core
                               VENCore *core = [[VENCore alloc] init];
                               [core setAccessToken:self.accessToken];
                               [VENCore setDefaultCore:core];

                               if (completionHandler) {
                                   completionHandler(accessToken, YES, nil);
                               }
                           }];
}


- (void)close {
    self.accessToken = nil;
    self.refreshToken = nil;
    self.expirationDate = nil;
    self.user = nil;
    self.state = VENSessionStateClosed;
}

- (BOOL)saveWithAppId:(NSString *)appId {
    VENKeychain *keychain = [[self class] keychain];
    NSString *account = [[self class] keychainAccountForAppID:appId];
    return [keychain setObject:self forAccount:account error:nil];
}

+ (instancetype)cachedSessionWithAppId:(NSString *)appId {
    NSString *account = [self keychainAccountForAppID:appId];
    return (VENSession *)[[self keychain] objectForAccount:account error:nil];
}

+ (BOOL)deleteSessionWithAppId:(NSString *)appId {
    NSString *account = [self keychainAccountForAppID:appId];
    return [[self keychain] removeObjectForAccount:account error:nil];
}

+ (VENKeychain *)keychain {
    return [[VENKeychain alloc] initWithService:kVENKeychainServiceName];
}

+ (NSString *)keychainAccountForAppID:(NSString *)appID {
    return [kVENKeychainAccountNamePrefix stringByAppendingString:appID];
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
