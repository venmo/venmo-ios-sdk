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

    [self.client URLProtocolDidFinishLoading:self];
}


- (void)stopLoading {

}


@end
