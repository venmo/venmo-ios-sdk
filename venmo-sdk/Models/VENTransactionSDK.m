#import <Foundation/Foundation.h>
#import "VENDefines_Internal.h"
#import "NSDictionary+VenmoSDk.h"
#import "Venmo.h"
#import "NSURL+VenmoSDK.h"
#import "VENRequestDecoder.h"

@interface VENTransactionSDK ()
@property (strong, nonatomic) NSNumberFormatter *amountNumberFormatter;
@end

@implementation VENTransactionSDK

+ (instancetype)transactionWithType:(VENTransactionType)type
                             amount:(NSUInteger)amount
                               note:(NSString *)note
                          recipient:(NSString *)recipient {
    VENTransactionSDK *transaction = [[VENTransactionSDK alloc] init];
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

        NSArray *decodedSignedRequest = [VENRequestDecoder decodeSignedRequest:signedRequest withClientSecret:[[Venmo sharedClient] appSecret]];
        DLog(@"decodedSignedRequest: %@", decodedSignedRequest);
        return [VENTransactionSDK transactionWithDictionary:decodedSignedRequest[0]];
    }
    @catch (NSException *exception) {
        DLog(@"Exception! %@: %@. %@", exception.name, exception.reason, exception.userInfo);
        return nil;
    }
}

+ (VENTransactionType)typeWithString:(NSString *)string {
    return [[string lowercaseString] isEqualToString:@"charge"] ?
    VENTransactionTypeCharge : VENTransactionTypePay;
}

- (NSString *)typeString {
    return self.type == VENTransactionTypeCharge ? @"charge" : @"pay";
}

- (NSString *)typeStringPast {
    return self.type == VENTransactionTypeCharge ? @"charged" : @"paid";
}

- (NSString *)amountString {
    if (self.amount < 1) {
        return @"";
    }
    CGFloat amount = self.amount / 100.0f;
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
    VENTransactionSDK *transaction = [[VENTransactionSDK alloc] init];
    transaction.transactionID = [dictionary stringForKey:@"payment_id"];
    transaction.type          = [VENTransactionSDK typeWithString:dictionary[@"verb"]];
    transaction.fromUserID    = [dictionary stringForKey:@"actor_user_id"];
    transaction.toUserID      = [dictionary stringForKey:@"target_user_id"];
    transaction.amount        = [[dictionary stringForKey:@"amount"] floatValue] * 100;
    transaction.note          = [dictionary stringForKey:@"note"];
    transaction.success       = [dictionary boolForKey:@"success"];
    return transaction;
}

@end
