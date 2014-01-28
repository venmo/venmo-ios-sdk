#import "VDKURLProtocol.h"
#import "VenmoSDK.h"
#import "VenmoErrors.h"
#import "NSError+Venmo.h"
#import "NSURL+Venmo.h"

@implementation VDKURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    NSString *requestScheme = [[request URL] scheme];
    NSString *currentAppScheme = [NSString stringWithFormat:@"venmo%@", [[VenmoSDK sharedClient] appId]];
    return [requestScheme isEqualToString:currentAppScheme];
}


- (instancetype)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id<NSURLProtocolClient>)client {
    self = [super initWithRequest:request cachedResponse:cachedResponse client:client];

    if (self) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self handleRequest];
        });

    }
    return self;
}


- (void)handleRequest {
    NSString *host                  = [self.request.URL host];
    NSDictionary *queryDictionary   = [self.request.URL queryDictionary];

    if ([host isEqualToString:@"oauth"]) {

        NSString *oauthErrorMessage = [queryDictionary valueForKey:@"error"];
        if (oauthErrorMessage) {
            NSLog(@"Could not complete oAuth Request, %@", oauthErrorMessage);
            return;
        }

        NSString *code = [queryDictionary valueForKey:@"code"];
        NSString *postString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&code=%@", [VenmoSDK sharedClient].appId, [VenmoSDK sharedClient].appSecret, code];
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
        VenmoSDK *client = [VenmoSDK sharedClient];
        client.currentUser = currentUser;
        client.currentSession = currentSession;

        dispatch_async(dispatch_get_main_queue(), ^{
            // Call oAuthComplete completion handler
        });

    }
    else {

        VDKTransaction *transaction = [VDKTransaction transactionWithURL:[self.request URL]];

        dispatch_async(dispatch_get_main_queue(), ^{

            if (transaction && [transaction success] && [VenmoSDK sharedClient].currentCompletionHandler) {
                [VenmoSDK sharedClient].currentCompletionHandler(transaction, nil);
            }
            else if (transaction && [VenmoSDK sharedClient].currentCompletionHandler) {
                NSError *err = [NSError errorWithDomain:VenmoErrorDomain code:VenmoTransactionFailedError
                                            description:@"Venmo failed to complete the transaction."
                                     recoverySuggestion:@"Please try again."];
                [VenmoSDK sharedClient].currentCompletionHandler(transaction, err);
            }
            else if ([VenmoSDK sharedClient].currentCompletionHandler) {
                NSError *err  = [NSError errorWithDomain:VenmoErrorDomain code:VenmoTransactionValidationError
                                             description:@"Failed to validate the transaction."
                                      recoverySuggestion:@"Please contact us."];
                [VenmoSDK sharedClient].currentCompletionHandler(transaction, err);
            }
        });
    }
}

@end

