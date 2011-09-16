#import <Kiwi/Kiwi.h>

#import "VenmoTransaction.h"
#import "VenmoTransaction_Internal.h"

SPEC_BEGIN(VenmoTransactionSpecs)

describe(@"VenmoTransaction", ^{
    __block VenmoTransaction *transaction;
    
    beforeEach(^{
        transaction = [[VenmoTransaction alloc] init];
        transaction.id = 1234;
        transaction.type = VenmoTransactionTypePay;
        transaction.amount = 3.45f;
        transaction.note = @"hello world";
        transaction.toUserHandle = @"shreyanstest";
    });

    it(@"should exist", ^{ [transaction shouldNotBeNil]; });

    describe(@"properties", ^{
        specify(^{ [[theValue(transaction.id) should] equal:theValue(1234)]; });
        specify(^{ [[theValue(transaction.type) should]
                             equal:theValue(VenmoTransactionTypePay)]; });
        specify(^{ [[theValue(transaction.amount) should] equal:theValue(3.45f)]; });
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
