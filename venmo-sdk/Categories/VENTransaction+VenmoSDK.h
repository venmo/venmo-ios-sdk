#import <VENCore/VENTransaction.h>

@interface VENTransaction (VenmoSDK)

/// Returns a transaction initialized with the given url containing a signed request.
+ (instancetype)transactionWithURL:(NSURL *)url;

/// Returns a string representation of the transaction amount
- (NSString *)amountString;

/// Returns a string representation of the transaction type
- (NSString *)typeString;

@end
