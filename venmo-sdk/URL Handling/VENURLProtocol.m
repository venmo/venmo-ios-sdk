#import "VENURLProtocol.h"
#import "Venmo_Internal.h"
#import "VENErrors.h"
#import "NSError+VenmoSDK.h"
#import "NSURL+VenmoSDK.h"

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
            NSString *oAuthErrorMessage = queryDictionary[@"message"];
            NSError *oAuthError = [NSError errorWithDomain:VENErrorDomain
                                                      code:VENTransactionFailedError
                                               description:oAuthErrorMessage
                                        recoverySuggestion:@"Please try again."];
            if ([Venmo sharedInstance].currentOAuthCompletionHandler) {
                [Venmo sharedInstance].currentOAuthCompletionHandler(NO, oAuthError);
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
        VENUser *currentUser = [[VENUser alloc] initWithDictionary:json[@"user"]];
        client.currentUser = currentUser;

        // Open the current session
        NSString *accessToken = json[@"access_token"];
        NSString *refreshToken = json[@"refresh_token"];
        NSUInteger expiresIn = [json[@"expires_in"] integerValue];
        [client.currentSession openWithAccessToken:accessToken
                                      refreshToken:refreshToken
                                         expiresIn:expiresIn];

        // Save the session
        [client.currentSession saveWithAppId:client.appId];

        dispatch_async(dispatch_get_main_queue(), ^{
            if ([Venmo sharedInstance].currentOAuthCompletionHandler) {
                BOOL success = (error == nil);
                [Venmo sharedInstance].currentOAuthCompletionHandler(success, error);
            }
        });
    }
    else {
        VENTransaction *transaction = [VENTransaction transactionWithURL:[self.request URL]];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error;
            if (transaction && transaction.status == VENTransactionStatusFailed) {
                error = [NSError errorWithDomain:VENErrorDomain
                                            code:VENTransactionFailedError
                                     description:@"Venmo failed to complete the transaction."
                              recoverySuggestion:@"Please try again."];
            } else if (transaction.status == VENTransactionStatusFailed) {
                error  = [NSError errorWithDomain:VENErrorDomain
                                             code:VENTransactionValidationError
                                      description:@"Failed to validate the transaction."
                               recoverySuggestion:@"Please contact us."];
            }

            if ([Venmo sharedInstance].currentTransactionCompletionHandler) {
                [Venmo sharedInstance].currentTransactionCompletionHandler(transaction, transaction.status, error);
            }
        });
    }
    [self.client URLProtocolDidFinishLoading:self];
}


- (void)stopLoading {

}


@end
