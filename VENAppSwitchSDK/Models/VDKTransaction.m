#import <Foundation/Foundation.h>
#import "VenmoDefines_Internal.h"
#import "NSDictionary+Venmo.h"
#import "VenmoSDK.h"
#import "NSURL+Venmo.h"
#import "VDKRequestDecoder.h"

@interface VDKTransaction ()
@property (strong, nonatomic) NSNumberFormatter *amountNumberFormatter;
@end

@implementation VDKTransaction

+ (instancetype)transactionWithType:(VDKTransactionType)type
                             amount:(NSUInteger)amount
                               note:(NSString *)note
                          recipient:(NSString *)recipient {
    VDKTransaction *transaction = [[VDKTransaction alloc] init];
    transaction.type = type;
    transaction.amount = amount;
    transaction.note = note;
    transaction.toUserHandle = recipient;
    return transaction;
}

+ (instancetype)transactionWithURL:(NSURL *)url {
    @try {
        NSString *signedRequest = [[url queryDictionary] stringForKey:@"signed_request"];
        DLog(@"signedRequest: %@", signedRequest);

        NSArray *decodedSignedRequest = [VDKRequestDecoder decodeSignedRequest:signedRequest withClientSecret:[[VenmoSDK sharedClient] appSecret]];
        DLog(@"decodedSignedRequest: %@", decodedSignedRequest);
        return [VDKTransaction transactionWithDictionary:decodedSignedRequest[0]];
    }
    @catch (NSException *exception) {
        DLog(@"Exception! %@: %@. %@", exception.name, exception.reason, exception.userInfo);
        return nil;
    }
}

+ (VDKTransactionType)typeWithString:(NSString *)string {
    return [[string lowercaseString] isEqualToString:@"charge"] ?
    VDKTransactionTypeCharge : VDKTransactionTypePay;
}

- (NSString *)typeString {
    return self.type == VDKTransactionTypeCharge ? @"charge" : @"pay";
}

- (NSString *)typeStringPast {
    return self.type == VDKTransactionTypeCharge ? @"charged" : @"paid";
}

- (NSString *)amountString {
    if (self.amount < 1) {
        return @"";
    }
    float amount = (float)self.amount / (float)100;
    NSString *amountStr = [NSString stringWithFormat:@"%.2f", amount];
    return amountStr;
}


#pragma mark - Private

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
+ (instancetype)transactionWithDictionary:(NSDictionary *)dictionary {
    DLog(@"transaction Dictionary: %@", dictionary);
    if (!dictionary) return nil;
    VDKTransaction *transaction = [[VDKTransaction alloc] init];
    transaction.transactionID = [dictionary stringForKey:@"payment_id"];
    transaction.type          = [VDKTransaction typeWithString:dictionary[@"verb"]];
    transaction.fromUserID    = [dictionary stringForKey:@"actor_user_id"];
    transaction.toUserID      = [dictionary stringForKey:@"target_user_id"];
    transaction.amount        = [[dictionary stringForKey:@"amount"] floatValue] * 100;
    transaction.note          = [dictionary stringForKey:@"note"];
    transaction.success       = [dictionary boolForKey:@"success"];
    return transaction;
}

@end
