#import "VENURLProtocol.h"
#import "Venmo_Internal.h"
#import "VENErrors.h"
#import "NSError+VenmoSDK.h"
#import "NSURL+VenmoSDK.h"

@implementation VENURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    NSString *requestScheme = [[request URL] scheme];
    NSString *currentAppScheme = [NSString stringWithFormat:@"venmo%@", [[Venmo sharedClient] appId]];
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
            if ([Venmo sharedClient].currentOAuthCompletionHandler) {
                [Venmo sharedClient].currentOAuthCompletionHandler(NO, oAuthError);
            }

            return;
        }

        NSString *code = [queryDictionary valueForKey:@"code"];
        NSString *postString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&code=%@", [Venmo sharedClient].appId, [Venmo sharedClient].appSecret, code];

        NSString *accessTokenURLString = [NSString stringWithFormat:@"%@oauth/access_token", [[Venmo sharedClient] baseURLPath]];
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
        // TODO: returned user should have the new API shape
        VENUser *currentUser = [[VENUser alloc] initWithDictionary:json[@"user"]];
        VENSession *currentSession = [[VENSession alloc] initWithAccessToken:json[@"access_token"]
                                                                refreshToken:json[@"refresh_token"]
                                                                   expiresIn:[json[@"expires_in"] integerValue]];
        Venmo *client = [Venmo sharedClient];
        client.currentUser = currentUser;
        client.currentSession = currentSession;

        dispatch_async(dispatch_get_main_queue(), ^{
            if ([Venmo sharedClient].currentOAuthCompletionHandler) {
                BOOL success = (error == nil);
                [Venmo sharedClient].currentOAuthCompletionHandler(success, error);
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

            if ([Venmo sharedClient].currentTransactionCompletionHandler) {
                [Venmo sharedClient].currentTransactionCompletionHandler(transaction, transaction.status, error);
            }
        });
    }
    [self.client URLProtocolDidFinishLoading:self];
}


- (void)stopLoading {

}


@end
