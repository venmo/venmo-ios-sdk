#import "VenmoDefines_Internal.h"
#import "NSBundle+Venmo.h"
#import "NSDictionary+Venmo.h"
#import "NSError+Venmo.h"
#import "NSURL+Venmo.h"
#import "VenmoBase64_Internal.h"
#import "VenmoClient_Private.h"
#import "VenmoClient_Internal.h"
#import "VenmoClient.h"
#import "VenmoErrors.h"
#import "VenmoHMAC_SHA256_Internal.h"
#import "VenmoTransaction_Internal.h"
#import "VenmoTransaction.h"
#import "VenmoViewController_Internal.h"
#import "VenmoViewController.h"

@implementation VenmoClient

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_5_0
@synthesize delegate;
#endif
@synthesize appId;
@synthesize appSecret;
@synthesize appName;
@synthesize appLocalId;

#pragma mark - Initializers

+ (id)clientWithAppId:(NSString *)theAppId secret:(NSString *)theAppSecret {
    return [self clientWithAppId:theAppId secret:theAppSecret name:nil];
}

+ (id)clientWithAppId:(NSString *)theAppId secret:(NSString *)theAppSecret
                 name:(NSString *)theAppName {
    return [self clientWithAppId:theAppId secret:theAppSecret name:theAppName localId:nil];
}

+ (id)clientWithAppId:(NSString *)theAppId secret:(NSString *)theAppSecret
              localId:(NSString *)theAppLocalId {
    return [self clientWithAppId:theAppId secret:theAppSecret name:nil localId:theAppLocalId];
}

+ (id)clientWithAppId:(NSString *)theAppId secret:(NSString *)theAppSecret
                 name:(NSString *)theAppName localId:(NSString *)theAppLocalId {
    return [[self alloc] initWithAppId:theAppId secret:theAppSecret name:theAppName
                               localId:theAppLocalId];
}

#pragma mark - Initializers @private

- (id)initWithAppId:(NSString *)theAppId secret:(NSString *)theAppSecret
               name:(NSString *)theAppName localId:(NSString *)theAppLocalId {
    self = [super init];
    if (self) {
        appId = [theAppId copy];
        appSecret = [theAppSecret copy];
        appName = theAppName ? theAppName : [[NSBundle mainBundle] name];
        appLocalId = [theAppLocalId copy];
    }
    return self;
}

#pragma mark - Sending a Transaction

- (VenmoViewController *)viewControllerWithTransaction:(VenmoTransaction *)transaction {
    return [self viewControllerWithTransaction:transaction forceWeb:NO];
}

- (VenmoViewController *)viewControllerWithTransaction:(VenmoTransaction *)transaction
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
    VenmoViewController *viewController = [[VenmoViewController alloc] init];
    viewController.transactionURL = transactionURL;
    viewController.venmoClient = self;
    return viewController;
}

#pragma mark - Sending a Transaction @private

- (NSString *)URLPathWithTransaction:(VenmoTransaction *)transaction {
    NSString *pathAndQuery = [NSString stringWithFormat:@"/?client=ios&"
            "app_name=%@&app_id=%@%@&device_id=%@",
            appName,
            appId,
            (appLocalId ? [NSString stringWithFormat:@"&app_local_id=%@", appLocalId] : @""),
            [[UIDevice currentDevice] uniqueIdentifier]];
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
    return [[NSURL alloc] initWithString: [NSString stringWithFormat:@"venmosdk://venmo.com%@", path]];
}

- (NSURL *)webURLWithPath:(NSString *)path {
    path = [@"/touch/signup_to_pay" stringByAppendingString:path];
    NSString *unEncodedURL = [NSString stringWithFormat:@"%@://%@%@", @"https", @"venmo.com", path];
    return [[NSURL alloc] initWithString:[unEncodedURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
    return [NSString stringWithFormat:@"venmo%@%@", appId, (appLocalId ? appLocalId : @"")];
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

+ (NSString *)urlencode:(NSString *)theURL {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[theURL UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

@end
