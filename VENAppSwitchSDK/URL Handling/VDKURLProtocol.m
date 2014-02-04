#import "VDKURLProtocol.h"
#import "VenmoSDK.h"
#import "VenmoErrors.h"
#import "NSError+Venmo.h"
#import "NSURL+Venmo.h"
#import "VenmoSDK_Private.h"

@implementation VDKURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    NSString *requestScheme = [[request URL] scheme];
    NSString *currentAppScheme = [NSString stringWithFormat:@"venmo%@", [[VenmoSDK sharedClient] appId]];
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
        NSString *oauthErrorMessage = [queryDictionary valueForKey:@"error"];

        if (oauthErrorMessage) {
            NSLog(@"Could not complete oAuth Request, %@", oauthErrorMessage);
            return;
        }

        NSString *code = [queryDictionary valueForKey:@"code"];
        NSString *postString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&code=%@", [VenmoSDK sharedClient].appId, [VenmoSDK sharedClient].appSecret, code];

        NSString *accessTokenURLString = [NSString stringWithFormat:@"%@oauth/access_token", [[VenmoSDK sharedClient] baseURLPath]];
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
        VDKUser *currentUser = [[VDKUser alloc] initWithJSON:json[@"user"]];
        VDKSession *currentSession = [[VDKSession alloc] initWithAccessToken:json[@"access_token"]
                                                                refreshToken:json[@"refresh_token"]
                                                                   expiresIn:[json[@"expires_in"] integerValue]];
        VenmoSDK *client = [VenmoSDK sharedClient];
        client.currentUser = currentUser;
        client.currentSession = currentSession;

        dispatch_async(dispatch_get_main_queue(), ^{
            if ([VenmoSDK sharedClient].currentOAuthCompletionHandler) {
                BOOL success = (error == nil);
                [VenmoSDK sharedClient].currentOAuthCompletionHandler(success, error);
            }
        });
    }
    else {
        VDKTransaction *transaction = [VDKTransaction transactionWithURL:[self.request URL]];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error;
            if (transaction && !transaction.success) {
                error = [NSError errorWithDomain:VDKErrorDomain
                                            code:VDKTransactionFailedError
                                     description:@"Venmo failed to complete the transaction."
                              recoverySuggestion:@"Please try again."];
            } else if (!transaction.success) {
                error  = [NSError errorWithDomain:VDKErrorDomain
                                             code:VDKTransactionValidationError
                                      description:@"Failed to validate the transaction."
                               recoverySuggestion:@"Please contact us."];
            }

            if ([VenmoSDK sharedClient].currentTransactionCompletionHandler) {
                [VenmoSDK sharedClient].currentTransactionCompletionHandler(transaction, transaction.success, error);
            }
        });
    }

    [self.client URLProtocolDidFinishLoading:self];
}


- (void)stopLoading {

}


@end
