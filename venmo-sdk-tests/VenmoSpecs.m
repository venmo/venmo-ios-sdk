#import "Venmo.h"

@interface Venmo (Private)

@property (assign, nonatomic) BOOL internalDevelopment;

- (NSString *)baseURLPath;

- (instancetype)initWithAppId:(NSString *)appId
                       secret:(NSString *)appSecret
                         name:(NSString *)appName;

- (NSString *)URLPathWithType:(VENTransactionType)type
                       amount:(NSUInteger)amount
                         note:(NSString *)note
                    recipient:(NSString *)recipientHandle;

- (NSString *)currentDeviceIdentifier;

@end

SpecBegin(Venmo)

describe(@"Initialization", ^{

    __block Venmo *venmo;

    beforeEach(^{
        venmo = [[Venmo alloc] initWithAppId:@"foo" secret:@"bar" name:@"Foo Bar App"];
    });

    it(@"should have an internal development flag", ^{
        expect(venmo.internalDevelopment).to.beFalsy();
        venmo.internalDevelopment = YES;
        expect(venmo.internalDevelopment).to.beTruthy();
    });

    it(@"should correctly set the app id, secret, and name", ^{
        expect(venmo.appId).to.equal(@"foo");
        expect(venmo.appSecret).to.equal(@"bar");
        expect(venmo.appName).to.equal(@"Foo Bar App");
    });
});

describe(@"baseURLPath", ^{

    __block Venmo *venmo;

    beforeEach(^{
        venmo = [[Venmo alloc] initWithAppId:@"foo" secret:@"bar" name:@"Foo Bar App"];
    });

    it(@"should return correct base URL path based on internal development flag.", ^{
        expect([venmo baseURLPath]).to.equal(@"http://api.venmo.com/v1/");
        venmo.internalDevelopment = YES;
        expect([venmo baseURLPath]).to.equal(@"http://api.devvenmo.com/v1/");
    });   
});

describe(@"startWithAppId:secret:name:", ^{

    it(@"should create a singleton instance", ^{
        BOOL started = [Venmo startWithAppId:@"foo" secret:@"bar" name:@"Foo Bar App"];
        expect(started).to.equal(YES);
        Venmo *sharedVenmo = [Venmo sharedInstance];
        expect(sharedVenmo).toNot.beNil();

        started = [Venmo startWithAppId:@"foo" secret:@"bar" name:@"Foo Bar App"];
        expect(started).to.equal(NO);
        expect([Venmo sharedInstance]).to.equal(sharedVenmo);
    });

});


describe(@"URLPathWithType:amount:note:recipient:", ^{

    __block Venmo *venmo;
    __block id mockVenmo;

    beforeEach(^{
        venmo = [[Venmo alloc] initWithAppId:@"foo" secret:@"bar" name:@"AppName"];
        mockVenmo = [OCMockObject partialMockForObject:venmo];
        [[[mockVenmo stub] andReturn:@"appId"] currentDeviceIdentifier];
    });

    it(@"should return the correct path for the given parameters", ^{
        NSString *path = [mockVenmo URLPathWithType:VENTransactionTypePay amount:100 note:@"test" recipient:@"cookie"];
        expect(path).to.equal(@"/?client=ios&app_name=AppName&app_id=foo&device_id=appId&amount=1.00&txn=charge&recipients=cookie&note=test&app_version=1.0.0");

    });

});

SpecEnd