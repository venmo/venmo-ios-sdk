#import <Foundation/Foundation.h>
#import "VenmoDefines_Internal.h"
#import "NSDictionary+Venmo.h"
#import "VenmoTransaction.h"
#import "VenmoTransaction_Internal.h"

@implementation VenmoTransaction {
    NSNumberFormatter *amountNumberFormatter;
}

@synthesize transactionID;
@synthesize type;
@synthesize fromUserID;
@synthesize toUserID;
@synthesize toUserHandle;
@synthesize amount;
@synthesize note;
@synthesize success;

+ (VenmoTransactionType)typeWithString:(NSString *)string {
    return [[string lowercaseString] isEqualToString:@"charge"] ?
    VenmoTransactionTypeCharge : VenmoTransactionTypePay;
}

- (NSString *)typeString {
    return type == VenmoTransactionTypeCharge ? @"charge" : @"pay";
}

- (NSString *)typeStringPast {
    return type == VenmoTransactionTypeCharge ? @"charged" : @"paid";
}

- (NSString *)amountString {
    if (!amount) {
        return @""; // we don't want to get the string "(null)"
    }
    // TODO: Consider making amountNumberFormatter a static variable and adding another static
    // variable called transactionCount, incremented in init & decremented in dealloc.
    // Then, in dealloc, if transactionCount == 0, set amountNumberFormatter = nil.
    if (!amountNumberFormatter) {
        amountNumberFormatter = [[NSNumberFormatter alloc] init];
        [amountNumberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [amountNumberFormatter setMinimumFractionDigits:2];
    }
    return [amountNumberFormatter stringFromNumber:amount];
}

#pragma mark - Internal

// {
//     "payments": [
//         {
//             "payment_id": "1234",
//             "verb": "pay",
//             "actor_user_id": "1",
//             "target_user_id": "2",
//             "amount": "1.00",
//             "note": "Have a drink on me!",
//             "success": 1
//         }
//     ]
// }
+ (id)transactionWithDictionary:(NSDictionary *)dictionary {
    DLog(@"transaction Dictionary: %@", dictionary);
    if (!dictionary) return nil;
    VenmoTransaction *transaction = [[VenmoTransaction alloc] init];
    transaction.transactionID = [dictionary stringForKey:@"payment_id"];
    transaction.type          = [VenmoTransaction typeWithString:[dictionary objectForKey:@"verb"]];
    transaction.fromUserID    = [dictionary stringForKey:@"actor_user_id"];
    transaction.toUserID      = [dictionary stringForKey:@"target_user_id"];
    transaction.amount        = [NSDecimalNumber decimalNumberWithString:
                                 [dictionary stringForKey:@"amount"]];
    transaction.note          = [dictionary stringForKey:@"note"];
    transaction.success       = [dictionary boolForKey:@"success"];
    return transaction;
}

@end
