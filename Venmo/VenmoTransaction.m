#import <Foundation/Foundation.h>
#import "VenmoDefines_Internal.h"
#import "NSDictionary+Venmo.h"
#import "VenmoTransaction.h"
#import "VenmoTransaction_Internal.h"

@implementation VenmoTransaction

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
    return [NSString stringWithFormat:@"%.2f", amount];
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
    transaction.transactionID = [dictionary objectForKey:@"payment_id"];
    transaction.type          = [VenmoTransaction typeWithString:[dictionary objectForKey:@"verb"]];
    transaction.fromUserID    = [dictionary objectForKey:@"actor_user_id"];
    transaction.toUserID      = [dictionary objectForKey:@"target_user_id"];
    transaction.amount        = [[dictionary objectForKey:@"amount"] floatValue];
    transaction.note          = [dictionary objectForKey:@"note"];
    transaction.success       = [dictionary boolForKey:@"success"];
    return transaction;
}

@end
