#import <Foundation/Foundation.h>
#import "VenmoDefines_Internal.h"
#import "NSDictionary+Venmo.h"
#import "VenmoSDK.h"
#import "NSURL+Venmo.h"
#import "VDKRequestDecoder.h"

@implementation VDKTransaction {
    NSNumberFormatter *amountNumberFormatter;
}


+ (VenmoTransactionType)typeWithString:(NSString *)string {
    return [[string lowercaseString] isEqualToString:@"charge"] ?
    VenmoTransactionTypeCharge : VenmoTransactionTypePay;
}


- (NSString *)typeString {
    return self.type == VenmoTransactionTypeCharge ? @"charge" : @"pay";
}


- (NSString *)typeStringPast {
    return self.type == VenmoTransactionTypeCharge ? @"charged" : @"paid";
}


- (NSString *)amountString {
    if (!self.amount) {
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
    return [amountNumberFormatter stringFromNumber:self.amount];
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
    transaction.amount        = [NSDecimalNumber decimalNumberWithString:
                                 [dictionary stringForKey:@"amount"]];
    transaction.note          = [dictionary stringForKey:@"note"];
    transaction.success       = [dictionary boolForKey:@"success"];
    return transaction;
}

@end
