#import "VENKeychain.h"

SpecBegin(VENKeychain)

__block VENKeychain *testKeychain;

beforeEach(^{
    testKeychain = [[VENKeychain alloc] initWithService:@"VenmoSDK"];
});

describe(@"-initWithService:", ^{
    it(@"is initialized with the provided service", ^{
        expect(testKeychain.service).to.equal(@"VenmoSDK");
    });
});

describe(@"-stringForAccount:error:", ^{
    NSString *string = @"Password";
    NSString *account = @"ClientApp";

    afterEach(^{
        [testKeychain removeStringForAccount:account error:nil];
    });

    context(@"when there is a stored string", ^{
        it(@"returns the stored string", ^{
            [testKeychain setString:string forAccount:account error:nil];

            expect([testKeychain stringForAccount:account error:nil]).to.equal(@"Password");
        });
    });

    context(@"when there is no stored string", ^{
        it(@"returns nil", ^{
            expect([testKeychain stringForAccount:account error:nil]).to.beNil();
        });
    });
});

describe(@"-setString:forAccount:error:", ^{
    NSString *string = @"Password";
    NSString *account = @"ClientApp2";

    afterEach(^{
        [testKeychain removeStringForAccount:account error:nil];
    });

    context(@"when there is no string for the given account", ^{
        it(@"sets the string for the given account", ^{
            expect([testKeychain stringForAccount:account error:nil]).to.beNil();
            
            [testKeychain setString:string forAccount:account error:nil];
            
            expect([testKeychain stringForAccount:account error:nil]).to.equal(string);
        });
    });

    context(@"where there is a string for a given account", ^{
        it(@"updates the string", ^{
            NSString *updatedString = @"UpdatedPassword";
            [testKeychain setString:string forAccount:account error:nil];

            expect([testKeychain stringForAccount:account error:nil]).to.equal(string);

            [testKeychain setString:updatedString forAccount:account error:nil];

            expect([testKeychain stringForAccount:account error:nil]).to.equal(updatedString);
        });
    });
});

describe(@"-removeStringForAccount:error:", ^{
    it(@"removes the string for the given account", ^{
        NSString *string = @"Password";
        NSString *account = @"ClientApp3";

        [testKeychain setString:string forAccount:account error:nil];

        expect([testKeychain stringForAccount:account error:nil]).to.equal(string);

        [testKeychain removeStringForAccount:account error:nil];

        expect([testKeychain stringForAccount:account error:nil]).to.beNil();
    });
});

SpecEnd
