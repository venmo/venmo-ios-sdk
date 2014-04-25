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
        @"payment_id": @"1234",
        @"verb": @"pay",
        @"actor_user_id": @"1",
        @"target_user_id": @"2",
        @"amount": @"1.00",
        @"note": @"Have a drink on me!",
        @"success": @(1)
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


describe(@"amountString", ^{

    it(@"should return the correct type string for pay", ^{
        VENTransaction *transaction = [[VENTransaction alloc] init];
        transaction.transactionType = VENTransactionTypePay;

        expect([transaction typeString]).to.equal(@"pay");
    });

    it(@"should return the correct type string for charge", ^{
        VENTransaction *transaction = [[VENTransaction alloc] init];
        transaction.transactionType = VENTransactionTypeCharge;

        expect([transaction typeString]).to.equal(@"charge");
    });

});


describe(@"typeString", ^{

    VENTransaction *(^mockAmountTransaction)(NSUInteger) = ^(NSUInteger amount) {
        VENTransaction *transaction = [[VENTransaction alloc] init];
        id mockTarget = [OCMockObject mockForClass:[VENTransactionTarget class]];
        [[[mockTarget stub] andReturnValue:OCMOCK_VALUE(amount)] amount];
        transaction.target = mockTarget;
        return transaction;
    };

    it(@"should return the correct amount string for 0 pennies", ^{
        VENTransaction *mockTransaction = mockAmountTransaction(0);
        expect([mockTransaction amountString]).to.equal(@"");
    });

    it(@"should return the correct amount string for 1 penny", ^{
        VENTransaction *mockTransaction = mockAmountTransaction(1);
        expect([mockTransaction amountString]).to.equal(@"0.01");
    });

    it(@"should return the correct amount string for 99 pennies", ^{
        VENTransaction *mockTransaction = mockAmountTransaction(99);
        expect([mockTransaction amountString]).to.equal(@"0.99");
   });

    it(@"should return the correct amount string for 199 pennies", ^{
        VENTransaction *mockTransaction = mockAmountTransaction(199);
        expect([mockTransaction amountString]).to.equal(@"1.99");
    });

});

SpecEnd