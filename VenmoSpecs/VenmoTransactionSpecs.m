#import <Kiwi/Kiwi.h>

#import "VenmoTransaction.h"
#import "VenmoTransaction_Internal.h"

SPEC_BEGIN(VenmoTransactionSpecs)

describe(@"VenmoTransaction", ^{
    __block VenmoTransaction *transaction;

    beforeEach(^{
        transaction = [[VenmoTransaction alloc] init];
        transaction.transactionID = @"1234";
        transaction.type = VenmoTransactionTypePay;
        transaction.amount = [NSDecimalNumber decimalNumberWithString:@"3.45"];
        transaction.note = @"hello world";
        transaction.toUserHandle = @"shreyanstest";
    });

    it(@"should exist", ^{ [transaction shouldNotBeNil]; });

    describe(@"properties", ^{
        specify(^{ [[transaction.transactionID should] equal:@"1234"]; });
        specify(^{ [[theValue(transaction.type) should]
                             equal:theValue(VenmoTransactionTypePay)]; });
        specify(^{ [[transaction.amount should] equal:[NSDecimalNumber decimalNumberWithString:@"3.45"]]; });
        specify(^{ [[transaction.note should] equal:@"hello world"]; });
        specify(^{ [[transaction.toUserHandle should] equal:@"shreyanstest"]; });
    });

    describe(@"string property values", ^{
        specify(^{ [[[transaction typeString] should] equal:@"pay"]; });
        specify(^{ [[[transaction amountString] should] equal:@"3.45"]; });
    });

    describe(@"transactionWithDictionary:", ^{
        it(@"returns nil if dictionary is nil", ^{
            transaction = [VenmoTransaction transactionWithDictionary:nil];
            [transaction shouldBeNil];
        });

        it(@"returns a VenmoTransaction", ^{
            transaction = [VenmoTransaction transactionWithDictionary:[NSDictionary dictionary]];
            [[transaction should] beMemberOfClass:[VenmoTransaction class]];
        });
    });
});

SPEC_END
