#import "VENURLProtocol.h"
#import "VENErrors.h"
#import "NSError+VenmoSDK.h"
#import "NSURL+VenmoSDK.h"
#import "Venmo.h"

@interface Venmo (VENURLProtocol)

- (NSString *)baseURLPath;

@end

@implementation VENURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    NSString *requestScheme = [[request URL] scheme];
    NSString *currentAppScheme = [NSString stringWithFormat:@"venmo%@", [[Venmo sharedInstance] appId]];
    return [requestScheme isEqualToString:currentAppScheme];
}


+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}


+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return [[[a URL] resourceSpecifier] isEqualToString:[[b URL] resourceSpecifier]];
}

- (void)startLoading {
    NSString *host = [self.request.URL host];
    NSDictionary *queryDictionary = [self.request.URL queryDictionary];

    if ([host isEqualToString:@"oauth"]) {
        NSString *oAuthErrorCode = [queryDictionary valueForKey:@"error"];

        if (oAuthErrorCode) {
            NSString *oAuthErrorMessage = queryDictionary[@"message"] ?: @"";
            NSError *oAuthError = [NSError errorWithDomain:VenmoSDKDomain
                                                      code:VENSDKErrorTransactionFailed
                                               description:oAuthErrorMessage
                                        recoverySuggestion:@"Please try again."];
            if ([Venmo sharedInstance].OAuthCompletionHandler) {
                [Venmo sharedInstance].OAuthCompletionHandler(NO, oAuthError);
            }

            return;
        }

        NSString *code = [queryDictionary valueForKey:@"code"];
        NSString *postString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&code=%@",
                                [Venmo sharedInstance].appId, [Venmo sharedInstance].appSecret, code];

        NSString *accessTokenURLString = [NSString stringWithFormat:@"%@oauth/access_token", [[Venmo sharedInstance] baseURLPath]];
        NSURL *accessTokenURL = [NSURL URLWithString:accessTokenURLString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:accessTokenURL];
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
        Venmo *client = [Venmo sharedInstance];

        // Set the current user
        VENUser *user = [[VENUser alloc] initWithDictionary:json[@"user"]];

        // Open the current session
        NSDictionary *errorDictionary = json[@"error"];
        if (errorDictionary) {
            NSString *errorMessage = errorDictionary[@"message"] ?: @"";
            error = [NSError errorWithDomain:@"OAuth failed"
                                        code:VENSDKErrorOAuth
                                 description:errorMessage
                          recoverySuggestion:@"Please try again."];
        }
        else {
            NSString *accessToken = json[@"access_token"];
            NSString *refreshToken = json[@"refresh_token"];
            NSUInteger expiresIn = [json[@"expires_in"] integerValue];
            [client.session openWithAccessToken:accessToken
                                   refreshToken:refreshToken
                                      expiresIn:expiresIn
                                           user:user];

            // Save the session
            [client.session saveWithAppId:client.appId];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            if ([Venmo sharedInstance].OAuthCompletionHandler) {
                BOOL success = (error == nil);
                [Venmo sharedInstance].OAuthCompletionHandler(success, error);
            }
        });
    }
    else {
        VENTransaction *transaction = [VENTransaction transactionWithURL:[self.request URL]];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error;
            if (transaction && transaction.status == VENTransactionStatusFailed) {
                error = [NSError errorWithDomain:VenmoSDKDomain
                                            code:VENSDKErrorTransactionFailed
                                     description:@"Venmo failed to complete the transaction."
                              recoverySuggestion:@"Please try again."];
            } else if (transaction.status == VENTransactionStatusFailed) {
                error  = [NSError errorWithDomain:VenmoSDKDomain
                                             code:VENSDKErrorTransactionValidationError
                                      description:@"Failed to validate the transaction."
                               recoverySuggestion:@"Please contact us."];
            }

            if ([Venmo sharedInstance].transactionCompletionHandler) {
                [Venmo sharedInstance].transactionCompletionHandler(transaction, transaction.status, error);
            }
        });
    }
    [self.client URLProtocolDidFinishLoading:self];
}


- (void)stopLoading {

}


@end
