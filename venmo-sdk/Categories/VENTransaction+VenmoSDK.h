#import <VENCore/VENTransaction.h>

@interface VENTransaction (VenmoSDK)

/// Returns a transaction initialized with the given url containing a signed request.
+ (instancetype)transactionWithURL:(NSURL *)url;

/// Returns a string representation in dollars of the given transaction amount in cents.
+ (NSString *)amountString:(NSUInteger)amount;

/// Returns a string representation of the given transaction type
+ (NSString *)typeString:(VENTransactionType)type;

@end
