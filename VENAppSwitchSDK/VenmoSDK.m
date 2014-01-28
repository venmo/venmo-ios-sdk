#import "VenmoDefines_Internal.h"
#import "NSBundle+Venmo.h"
#import "NSDictionary+Venmo.h"
#import "NSError+Venmo.h"
#import "NSURL+Venmo.h"
#import "VenmoBase64_Internal.h"
#import "VenmoSDK.h"
#import "VenmoErrors.h"
#import "VenmoHMAC_SHA256_Internal.h"
#import "VDKTransaction.h"
#import "VDKTransactionViewController.h"
#import "VDKURLProtocol.h"
#import "VDKSession.h"
#import "VDKUser.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
#import "UIDevice+IdentifierAddition.h"
#endif

static VenmoSDK *sharedVenmoClient = nil;

@interface VenmoSDK ()

@property (copy, nonatomic, readwrite) NSString *appId;
@property (copy, nonatomic, readwrite) NSString *appSecret;
@property (copy, nonatomic, readwrite) NSString *appName;
@property (copy, nonatomic, readwrite) NSString *appLocalId;

@property (copy, nonatomic, readwrite) VDKTransactionCompletionHandler currentTransactionCompletionHandler;
@property (copy, nonatomic, readwrite) VDKOAuthCompletionHandler currentOAuthCompletionHandler;

@property (copy, nonatomic) NSString *accessToken;
@property (copy, nonatomic) NSString *refreshToken;

@end

@implementation VenmoSDK

#pragma mark - Initializers

+ (BOOL)startWithAppId:(NSString *)appId
                secret:(NSString *)appSecret
                  name:(NSString *)appName
               localId:(NSString *)appLocalId {
    if (sharedVenmoClient) {
        return NO;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedVenmoClient = [[self alloc] initWithAppId:appId secret:appSecret name:appName localId:appLocalId];
    });
    return YES;
}

+ (instancetype)sharedClient {
    return sharedVenmoClient;
}

- (BOOL)isConnected {
    if (!self.currentSession) {
        return NO;
    }
    return YES;
}


#pragma mark - Sending a Transaction

- (void)sendTransaction:(VDKTransaction *)transaction
  withCompletionHandler:(VDKTransactionCompletionHandler)completionHandler {

    self.currentTransactionCompletionHandler = completionHandler;
    NSString *URLPath = [self URLPathWithTransaction:transaction];
    NSURL *transactionURL;
    transactionURL = [self venmoURLWithPath:URLPath];
    DLog(@"transactionURL: %@", transactionURL);

    if ([self hasVenmoApp]) {
        [[UIApplication sharedApplication] openURL:transactionURL];
    } else {
        VDKTransactionViewController *viewController = [[VDKTransactionViewController alloc] init];
        viewController.transactionURL = [self webURLWithPath:URLPath];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];

        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow.rootViewController presentViewController:navController animated:YES completion:nil];
    }
}


#pragma mark - OAuth

- (void)requestPermissions:(NSArray *)permissions
     withCompletionHandler:(VDKOAuthCompletionHandler)completionHandler {
    NSString *scopeURLEncoded = [permissions componentsJoinedByString:@"%20"];
    self.currentOAuthCompletionHandler = completionHandler;

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

- (NSString *)URLPathWithTransaction:(VDKTransaction *)transaction {

    NSString *identifier = [self currentDeviceIdentifier];

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
    pathAndQuery = [NSString stringWithFormat:@"%@&app_version=%@", pathAndQuery, VDK_CURRENT_SDK_VERSION];

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


#pragma mark - Private

- (instancetype)initWithAppId:(NSString *)appId
                       secret:(NSString *)appSecret
                         name:(NSString *)appName
                      localId:(NSString *)appLocalId {
    self = [super init];
    if (self) {
        self.appId = appId;
        self.appSecret = appSecret;
        self.appName = appName ?: [[NSBundle mainBundle] name];
        self.appLocalId = appLocalId;

        [NSURLProtocol registerClass:[VDKURLProtocol class]];
    }
    return self;
}

- (BOOL)hasVenmoApp {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"venmo://"]];
}

- (NSString *)currentDeviceIdentifier {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    } else {
        return [[UIDevice currentDevice] uniqueDeviceIdentifier];
    }
#else
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
#endif
}

@end
