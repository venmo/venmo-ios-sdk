#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <Specta/Specta.h>

#import "VENTransaction.h"

SpecBegin(VENTransaction)

describe(@"Initialization", ^{

    it(@"should initialize with basic params.", ^{
        VENTransactionType type = VENTransactionTypePay;
        NSUInteger amount = 100;
        NSString *note = @"Octocats rule the world.";
        NSString *recipient = @"octocat";

        VENTransaction *transaction = [VENTransaction transactionWithType:type amount:amount note:note recipient:recipient];

        expect(transaction.type).to.equal(type);
        expect(transaction.amount).to.equal(amount);
        expect(transaction.note).to.equal(note);
        expect(transaction.toUserHandle).to.equal(recipient);
    });

});

describe(@"Type strings", ^{

    it(@"should return the correct type string for pay", ^{
        VENTransaction *transaction = [VENTransaction transactionWithType:VENTransactionTypePay amount:1 note:@"foo" recipient:@"bar"];
        expect([transaction typeString]).to.equal(@"pay");
    });

    it(@"should return the corrent type string for charge", ^{
        VENTransaction *transaction = [VENTransaction transactionWithType:VENTransactionTypeCharge amount:1 note:@"foo" recipient:@"bar"];
        expect([transaction typeString]).to.equal(@"charge");
    });

    it(@"should return the correct past tense type string for pay", ^{
        VENTransaction *transaction = [VENTransaction transactionWithType:VENTransactionTypePay amount:1 note:@"foo" recipient:@"bar"];
        expect([transaction typeStringPast]).to.equal(@"paid");
    });

    it(@"should return the correct past tense type string for charge", ^{
        VENTransaction *transaction = [VENTransaction transactionWithType:VENTransactionTypeCharge amount:1 note:@"foo" recipient:@"bar"];
        expect([transaction typeStringPast]).to.equal(@"charged");
    });

});

describe(@"Amount string", ^{

    it(@"should return the correct amount string for 0 pennies", ^{
        VENTransaction *transaction = [VENTransaction transactionWithType:VENTransactionTypePay amount:0 note:@"foo" recipient:@"bar"];
        expect([transaction amountString]).to.equal(@"");
    });

    it(@"should return the correct amount string for 1 penny", ^{
        VENTransaction *transaction = [VENTransaction transactionWithType:VENTransactionTypePay amount:1 note:@"foo" recipient:@"bar"];
        expect([transaction amountString]).to.equal(@"0.01");
    });

    it(@"should return the correct amount string for 99 pennies", ^{
        VENTransaction *transaction = [VENTransaction transactionWithType:VENTransactionTypePay amount:99 note:@"foo" recipient:@"bar"];
        expect([transaction amountString]).to.equal(@"0.99");
    });

    it(@"should return the correct amount string for 199 pennies", ^{
        VENTransaction *transaction = [VENTransaction transactionWithType:VENTransactionTypePay amount:199 note:@"foo" recipient:@"bar"];
        expect([transaction amountString]).to.equal(@"1.99");
    });

});

SpecEnd