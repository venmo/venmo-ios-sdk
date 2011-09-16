#import <Foundation/Foundation.h>

#import "VenmoDefines_Internal.h"
#import "NSDictionary+Venmo.h"
#import "VenmoTransaction.h"
#import "VenmoTransaction_Internal.h"

@implementation VenmoTransaction

@synthesize id;
@synthesize type;
@synthesize fromUserId;
@synthesize toUserId;
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

//{
//  "payments": [
//                 {
//                   "payment_id": 1234, 
//                   "verb": "pay", 
//                   "actor_user_id": 1,
//                   "target_user_id": 2, 
//                   "amount": "1.00", 
//                   "note": "for food", 
//                   "success": 1
//                 }
//              ]
//}
+ (id)transactionWithDictionary:(NSDictionary *)dictionary {
    DLog(@"transaction Dictionary: %@", dictionary);
    if (!dictionary) return nil;
    VenmoTransaction *transaction = [[VenmoTransaction alloc] init];
    transaction.id         = [dictionary unsignedIntegerForKey:@"payment_id"];
    transaction.type       = [VenmoTransaction typeWithString:[dictionary stringForKey:@"verb"]];
    transaction.fromUserId = [dictionary unsignedIntegerForKey:@"actor_user_id"];
    transaction.toUserId   = [dictionary unsignedIntegerForKey:@"target_user_id"];
    transaction.amount     = [[dictionary stringForKey:@"amount"] floatValue];
    transaction.note       = [dictionary stringForKey:@"note"];
    transaction.success    = [dictionary boolForKey:@"success"];
    return transaction;
}

@end
