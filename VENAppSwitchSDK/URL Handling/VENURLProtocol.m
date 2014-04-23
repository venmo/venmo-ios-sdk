#import "VENURLProtocol.h"
#import "Venmo.h"
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
    VENTransaction *transaction = [VENTransaction transactionWithURL:[self.request URL]];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error;
        if (transaction && !transaction.success) {
            error = [NSError errorWithDomain:VENErrorDomain
                                        code:VENTransactionFailedError
                                 description:@"Venmo failed to complete the transaction."
                          recoverySuggestion:@"Please try again."];
        } else if (!transaction.success) {
            error  = [NSError errorWithDomain:VENErrorDomain
                                         code:VENTransactionValidationError
                                  description:@"Failed to validate the transaction."
                           recoverySuggestion:@"Please contact us."];
        }

        if ([Venmo sharedClient].currentTransactionCompletionHandler) {
            [Venmo sharedClient].currentTransactionCompletionHandler(transaction, transaction.success, error);
        }
    });

    [self.client URLProtocolDidFinishLoading:self];
}


- (void)stopLoading {

}


@end
