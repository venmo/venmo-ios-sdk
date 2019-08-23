#import "VENTransaction+VenmoSDK.h"

@interface VENTransaction ()

@property (strong, nonatomic, readwrite) VENTransactionTarget *target;
@property (assign, nonatomic, readwrite) VENTransactionType transactionType;

+ (instancetype)transactionWithSignedRequestDictionary:(NSDictionary *)dictionary;

@end


SpecBegin(VENTransaction_VenmoSDK)

describe(@"transactionWithSignedRequestDictionary:", ^{

    NSDictionary *paymentsDictionary =
    @{
        @"id": @"1234",
        @"action": @"pay",
        @"actor_user_id": @"1",
        @"target_user_id": @"2",
        @"amount": @"1.00",
        @"note": @"Have a drink on me!",
        @"success": @(1),
        @"actor": @{
            @"id": @"1",
        },
        @"target": @{
            @"type": @"user",
            @"user": @{
                @"id": @"2"
            }
        }
    };

    it(@"should initialize with a payment dictionary.", ^{
        VENTransaction *transaction = [VENTransaction transactionWithSignedRequestDictionary:paymentsDictionary];

        expect(transaction.transactionID).to.equal(@"1234");
        expect(transaction.transactionType).to.equal(VENTransactionTypePay);
        expect(transaction.actor.externalId).to.equal(@"1");
        expect(transaction.target.amount).to.equal(100);
        expect(transaction.target.targetType).to.equal(VENTargetTypeUserId);
        expect(transaction.target.handle).to.equal(@"2");
        expect(transaction.note).to.equal(@"Have a drink on me!");
        expect(transaction.status).toNot.equal(VENTransactionStatusFailed);
    });

});


describe(@"typeString", ^{

    it(@"should return the correct type string for pay", ^{
        expect([VENTransaction typeString:VENTransactionTypePay]).to.equal(@"pay");
    });

    it(@"should return the correct type string for charge", ^{
        expect([VENTransaction typeString:VENTransactionTypeCharge]).to.equal(@"charge");
    });

});


describe(@"amountString", ^{

    it(@"should return the correct amount string for 0 pennies", ^{
        expect([VENTransaction amountString:0]).to.equal(@"");
    });

    it(@"should return the correct amount string for 1 penny", ^{
        expect([VENTransaction amountString:1]).to.equal(@"0.01");
    });

    it(@"should return the correct amount string for 99 pennies", ^{
        expect([VENTransaction amountString:99]).to.equal(@"0.99");
   });

    it(@"should return the correct amount string for 199 pennies", ^{
        expect([VENTransaction amountString:199]).to.equal(@"1.99");
    });
    
    it(@"should return the correct amount string for 940 pennies", ^{
        expect([VENTransaction amountString:940]).to.equal(@"9.40");
    });

});

SpecEnd
