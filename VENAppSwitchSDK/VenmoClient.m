#import "VenmoDefines_Internal.h"
#import "NSBundle+Venmo.h"
#import "NSDictionary+Venmo.h"
#import "NSError+Venmo.h"
#import "NSURL+Venmo.h"
#import "VenmoBase64_Internal.h"
#import "VenmoClient.h"
#import "VenmoErrors.h"
#import "VenmoHMAC_SHA256_Internal.h"
#import "VenmoTransaction.h"
#import "VDKTransactionViewController.h"
#import "VDKSession.h"
#import "VDKUser.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
#import "UIDevice+IdentifierAddition.h"
#endif

@interface VenmoClient (Private)
@property (copy, nonatomic) NSString *appId;
@property (copy, nonatomic) NSString *appSecret;
@property (copy, nonatomic) NSString *accessToken;
@property (copy, nonatomic) NSString *refreshToken;
@end

@implementation VenmoClient


#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_5_0
@synthesize delegate;
#endif

#pragma mark - Initializers

+ (id)clientWithAppId:(NSString *)appId
               secret:(NSString *)appSecret {
    return [self clientWithAppId:appId secret:appSecret name:nil];
}

+ (id)clientWithAppId:(NSString *)appId
               secret:(NSString *)appSecret
                 name:(NSString *)appName {
    return [self clientWithAppId:appId secret:appSecret name:appName localId:nil];
}

+ (id)clientWithAppId:(NSString *)appId
               secret:(NSString *)appSecret
              localId:(NSString *)appLocalId {
    return [self clientWithAppId:appId secret:appSecret name:nil localId:appLocalId];
}

+ (id)clientWithAppId:(NSString *)appId
               secret:(NSString *)appSecret
                 name:(NSString *)appName
              localId:(NSString *)appLocalId {
    return [[VenmoClient sharedClient] initWithAppId:appId secret:appSecret name:appName localId:appLocalId];
}

+ (id)sharedClient {
    static VenmoClient *sharedVenmoClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedVenmoClient = [[self alloc] init];
    });
    return sharedVenmoClient;
}

#pragma mark - Initializers @private

- (id)initWithAppId:(NSString *)appId
             secret:(NSString *)appSecret
               name:(NSString *)appName
            localId:(NSString *)appLocalId {
    //TODO: check for self
    _appId = [appId copy];
    _appSecret = [appSecret copy];
    self.appName = appName ?: [[NSBundle mainBundle] name];
    self.appLocalId = [appLocalId copy];
    return self;
}

#pragma mark - Sending a Transaction

- (VDKTransactionViewController *)viewControllerWithTransaction:(VenmoTransaction *)transaction {
    return [self viewControllerWithTransaction:transaction forceWeb:NO];
}

- (VDKTransactionViewController *)viewControllerWithTransaction:(VenmoTransaction *)transaction
                                              forceWeb:(BOOL)forceWeb {
    NSString *URLPath = [self URLPathWithTransaction:transaction];
    NSURL *transactionURL;
    if (!forceWeb) {
        transactionURL = [self venmoURLWithPath:URLPath];
        DLog(@"transactionURL: %@", transactionURL);
        if ([[UIApplication sharedApplication] canOpenURL:transactionURL]) {
            [[UIApplication sharedApplication] openURL:transactionURL];
            return nil;
        }
    }
    transactionURL = [self webURLWithPath:URLPath];
    DLog(@"transactionURL: %@", transactionURL);
    VDKTransactionViewController *viewController = [[VDKTransactionViewController alloc] init];
    viewController.transactionURL = transactionURL;
    viewController.venmoClient = self;
    return viewController;
}

- (BOOL)hasVenmoApp {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"venmo://"]];
}

- (void)connectWithController:(UIViewController *)controller scope:(NSArray *)scope {
    NSString *scopeURLEncoded = [scope componentsJoinedByString:@"%20"];
    NSString *baseURL;
    if ([self hasVenmoApp]) {
        baseURL = @"venmo://";
    } else {
        baseURL = @"http://api.devvenmo.com/v1/";
    }
    NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@oauth/authorize?sdk=ios&client_id=%@&scope=%@&response_type=code", baseURL, self.appId, scopeURLEncoded]];
    [[UIApplication sharedApplication] openURL:authURL];
}

#pragma mark - Sending a Transaction @private

- (NSString *)URLPathWithTransaction:(VenmoTransaction *)transaction {
    
    NSString *identifier = nil;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    } else {
        identifier = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    }
#else
    identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
#endif
    
    NSString *pathAndQuery = [NSString stringWithFormat:@"/?client=ios&"
            "app_name=%@&app_id=%@%@&device_id=%@",
            self.appName,
            self.appId,
            (self.appLocalId ? [NSString stringWithFormat:@"&app_local_id=%@", self.appLocalId] : @""),
            identifier];
    if (transaction.amount) {
        pathAndQuery = [NSString stringWithFormat:@"%@&amount=%@", pathAndQuery, transaction.amountString];
    }
    if (transaction.typeString) {
        pathAndQuery = [NSString stringWithFormat:@"%@&txn=%@", pathAndQuery, transaction.typeString];
    }
    if (transaction.toUserHandle) {
        pathAndQuery = [NSString stringWithFormat:@"%@&recipients=%@", pathAndQuery, transaction.toUserHandle];
    }
    if (transaction.note) {
        pathAndQuery = [NSString stringWithFormat:@"%@&note=%@", pathAndQuery, transaction.note];
    }
    return pathAndQuery;
}

- (NSURL *)venmoURLWithPath:(NSString *)path {
    NSString *newPath = [NSString stringWithFormat:@"venmosdk://venmo.com%@", path];
    return [[NSURL alloc] initWithString:[newPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (NSURL *)webURLWithPath:(NSString *)path {
    path = [@"/touch/signup_to_pay" stringByAppendingString:path];
    NSString *unEncodedURL = [NSString stringWithFormat:@"%@://%@%@", @"https", @"venmo.com", path];
    return [[NSURL alloc] initWithString:[unEncodedURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (BOOL)handleURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication {
    NSString            *host               = [url host];
    NSDictionary *queryDictionary    = [url queryDictionary];
    
    if ([host isEqualToString:@"oauth"]) {
        NSString *oauthErrorMessage = [queryDictionary valueForKey:@"error"];
        if (oauthErrorMessage) {
            NSLog(@"uh oh, %@", oauthErrorMessage);
            return YES;
        }
        NSString *code = [queryDictionary valueForKey:@"code"];
        NSString *postString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&code=%@", self.appId, self.appSecret, code];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://api.devvenmo.com/v1/oauth/access_token"]];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        NSError *error;
        NSURLResponse *response;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (error) {
           NSLog(@"Couldn't get the access token, %@", error);
        }
        NSError *jsonError;
        id json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
        VDKUser *currentUser = [[VDKUser alloc] initWithJSON:json[@"user"]];
        VDKSession *currentSession = [[VDKSession alloc] initWithAccessToken:json[@"access_token"]
                                                                   refreshToken:json[@"refresh_token"]
                                                                      expiresIn:[json[@"expires_in"] integerValue]];
        VenmoClient *client = [VenmoClient sharedClient];
        [client setCurrentUser:currentUser];
        [client setCurrentSession:currentSession];
    } else {
        return NO;
    }
    return YES;
}

- (BOOL) isConnected {
    if (!self.currentSession) {
        return NO;
    }
    return YES;
}

#pragma mark - Receiving a Transaction

- (BOOL)openURL:(NSURL *)url completionHandler:(VenmoTransactionCompletionHandler)completion {
    if (![[url scheme] isEqualToString:[self scheme]]) return NO;
    
    VenmoTransaction *transaction = [self transactionWithURL:url];
    DLog(@"transaction.note: %@", transaction.note);

    BOOL success = NO;
    NSError *error = nil;

    if (transaction) {
        if (transaction.success) {
            success = YES;
        } else {
            error = [NSError errorWithDomain:VenmoErrorDomain code:VenmoTransactionFailedError
                                 description:@"Venmo failed to complete the transaction."
                          recoverySuggestion:@"Please try again."];
        }
    } else {
        error = [NSError errorWithDomain:VenmoErrorDomain code:VenmoTransactionValidationError
                             description:[self.appName stringByAppendingString:
                                          @" failed to validate the transaction."]
                      recoverySuggestion:[NSString stringWithFormat:
                                          @"Please contact %@.", self.appName]];
        DLog(@"error_message=%@", [[url queryDictionary] stringForKey:@"error_message"]);
    }
    completion(transaction, error);
    return success;
}

#pragma mark - Receiving a Transaction @internal

- (NSString *)scheme {
    return [NSString stringWithFormat:@"venmo%@%@", self.appId, (self.appLocalId ?: @"")];
}

#pragma mark - Receiving a Transaction @private

- (VenmoTransaction *)transactionWithURL:(NSURL *)url {
    // TODO: Rm this try/catch.
    @try {
        NSString *signedRequest = [[url queryDictionary] stringForKey:@"signed_request"];
        DLog(@"signedRequest: %@", signedRequest);
        NSArray *decodedSignedRequest = [self decodeSignedRequest:signedRequest];
        DLog(@"decodedSignedRequest: %@", decodedSignedRequest);
        return [VenmoTransaction transactionWithDictionary:[decodedSignedRequest objectAtIndex:0]];
    }
    @catch (NSException *exception) {
        DLog(@"Exception! %@: %@. %@", exception.name, exception.reason, exception.userInfo);
        return nil;
    }
}

- (id)decodeSignedRequest:(NSString *)signedRequest {
    if (!signedRequest) return nil;

    NSArray *encodedSignature_encodedDataString = [signedRequest componentsSeparatedByString:@"."];
    NSString *encodedSignature = [encodedSignature_encodedDataString objectAtIndex:0];
    NSString *encodedDataString = [encodedSignature_encodedDataString objectAtIndex:1];

    encodedSignature = [encodedSignature stringByAppendingString:@"=="];
    encodedSignature = [encodedSignature stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
    encodedSignature = [encodedSignature stringByReplacingOccurrencesOfString:@"_" withString:@"/"];

    NSData *signature = [encodedSignature base64DecodedData];
    NSData *expectedSignature = VenmoHMAC_SHA256(self.appSecret, encodedDataString);

    if ([signature isEqualToData:expectedSignature]) {
        return [self JSONObjectWithData:[encodedDataString base64DecodedData]];
    }
    return nil;
}

- (id)JSONObjectWithData:(NSData *)data {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_5_0
    if (NSClassFromString(@"NSJSONSerialization")) {
        return [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    } else {
        return [delegate venmoClient:self JSONObjectWithData:data];
    }
#else
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
#endif
}

@end
