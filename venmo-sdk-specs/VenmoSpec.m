#import "Venmo.h"
#import "NSURL+VenmoSDK.h"

@interface VENSession (VenmoSpec)

@property (assign, nonatomic, readwrite) VENSessionState state;
@property (strong, nonatomic, readwrite) NSString *accessToken;
@property (strong, nonatomic, readwrite) NSDate *expirationDate;

@end

@interface Venmo (VenmoSpec)

@property (assign, nonatomic) BOOL internalDevelopment;

- (NSString *)baseURLPath;

- (instancetype)initWithAppId:(NSString *)appId
                       secret:(NSString *)appSecret
                         name:(NSString *)appName;

- (void)sendAPITransactionTo:(NSString *)recipientHandle
             transactionType:(VENTransactionType)type
                      amount:(NSUInteger)amount
                        note:(NSString *)note
                    audience:(VENTransactionAudience)audience
           completionHandler:(VENTransactionCompletionHandler)completionHandler;

- (void)sendAppSwitchTransactionTo:(NSString *)recipientHandle
                   transactionType:(VENTransactionType)type
                            amount:(NSUInteger)amount
                              note:(NSString *)note
                 completionHandler:(VENTransactionCompletionHandler)completionHandler;

- (void)sendTransactionTo:(NSString *)recipientHandle
          transactionType:(VENTransactionType)type
                   amount:(NSUInteger)amount
                     note:(NSString *)note
                 audience:(VENTransactionAudience)audience
        completionHandler:(VENTransactionCompletionHandler)completionHandler;

- (void)validateAPIRequestWithCompletionHandler:(VENGenericRequestCompletionHandler)handler;

- (NSString *)URLPathWithType:(VENTransactionType)type
                       amount:(NSUInteger)amount
                         note:(NSString *)note
                    recipient:(NSString *)recipientHandle;

- (NSString *)currentDeviceIdentifier;

@end

SpecBegin(Venmo)

#pragma mark - Initialization

describe(@"startWithAppId:secret:name: and sharedInstance", ^{

    __block NSString *appId = @"foobarbaz";

    afterAll(^{
        [VENSession deleteSessionWithAppId:appId];
    });

    it(@"should create a singleton instance", ^{
        [Venmo startWithAppId:appId secret:@"bar" name:@"Foo Bar App"];
        Venmo *sharedVenmo = [Venmo sharedInstance];
        expect(sharedVenmo).toNot.beNil();

        [Venmo startWithAppId:appId secret:@"bar" name:@"Foo Bar App"];
        expect([Venmo sharedInstance]).to.equal(sharedVenmo);
    });

});


describe(@"initWithAppId:secret:name:", ^{

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

    it(@"should correctly set the current session to a closed session", ^{
        expect(venmo.session.state).to.equal(VENSessionStateClosed);
    });

    it(@"should set the default transaction method to app switch", ^{
        expect(venmo.defaultTransactionMethod).to.equal(VENTransactionMethodAppSwitch);
    });
});


#pragma mark - Sessions

describe(@"requestPermissions:withCompletionHandler", ^{

    __block id mockApplication;
    __block id mockSharedApplication;
    __block id mockVenmo;
    __block Venmo *venmo;
    __block NSString *appId;
    __block NSString *appSecret;
    __block NSString *appName;

    beforeAll(^{
        // Turn [UIApplication sharedApplication] into a partial mock.
        mockApplication = [OCMockObject niceMockForClass:[UIApplication class]];
        mockSharedApplication = [OCMockObject niceMockForClass:[UIApplication class]];
        [[[mockApplication stub] andReturn:mockSharedApplication] sharedApplication];

        // Create a partial mock for Venmo
        appId = @"foo";
        appSecret = @"bar";
        appName = @"AppName";
        venmo = [[Venmo alloc] initWithAppId:appId secret:appSecret name:appName];
        mockVenmo = [OCMockObject partialMockForObject:venmo];
    });

    afterAll(^{
        [mockApplication stopMocking];
        [mockSharedApplication stopMocking];
        [mockVenmo stopMocking];
        [VENSession deleteSessionWithAppId:appId];
    });

    afterEach(^{
        [mockVenmo stopMocking];
    });

    it(@"should use venmo:// if venmoAppInstalled is true", ^{
        [[[mockVenmo stub] andReturnValue:OCMOCK_VALUE(YES)] isVenmoAppInstalled];
        [[mockSharedApplication expect] openURL:[OCMArg checkWithBlock:^BOOL(NSURL *url) {
            expect([url scheme]).to.equal(@"venmo");
            return YES;
        }]];
        [mockVenmo requestPermissions:@[] withCompletionHandler:nil];
    });

    it(@"should use baseURLPath if venmoAppInstalled is false", ^{
        [[[mockVenmo stub] andReturnValue:OCMOCK_VALUE(NO)] isVenmoAppInstalled];
        NSString *baseURLPath = [venmo baseURLPath];
        [[mockSharedApplication expect] openURL:[OCMArg checkWithBlock:^BOOL(NSURL *url) {
            expect([url absoluteString]).to.contain(baseURLPath);
            return YES;
        }]];
        [mockVenmo requestPermissions:@[] withCompletionHandler:nil];
    });

    it(@"should set the session state to opening", ^{
        [venmo requestPermissions:@[] withCompletionHandler:nil];
        expect(venmo.session.state).to.equal(VENSessionStateOpening);
    });

    it(@"should set the completion handler to the given handler", ^{
        VENOAuthCompletionHandler handler = ^(BOOL success, NSError *error) {
            NSString *foo;
            foo = @"foo";
        };
        [venmo requestPermissions:@[] withCompletionHandler:handler];
        expect(venmo.OAuthCompletionHandler).to.equal(handler);
    });

});


describe(@"isSessionValid", ^{

    __block id mockVenmo;
    __block VENSession *session;

    before(^{
        Venmo *venmo = [[Venmo alloc] initWithAppId:@"abcd" secret:@"12345" name:@"fooApp"];
        mockVenmo = [OCMockObject partialMockForObject:venmo];
        session = [[VENSession alloc] init];
    });

    it(@"should return YES if the session is open and has a non-expired token", ^{
        session.state = VENSessionStateOpen;
        session.expirationDate = [NSDate dateWithTimeIntervalSinceNow:100];
        [[[mockVenmo stub] andReturn:session] session];
        expect([mockVenmo isSessionValid]).to.beTruthy();
    });

    it(@"should return NO if the sesion is open and has an expired token", ^{
        session.state = VENSessionStateOpen;
        session.expirationDate = [NSDate dateWithTimeIntervalSinceNow:-10];
        [[[mockVenmo stub] andReturn:session] session];
        expect([mockVenmo isSessionValid]).to.beFalsy();
    });

    it(@"should return NO if the session is closed", ^{
        session.state = VENSessionStateClosed;
        session.expirationDate = [NSDate dateWithTimeIntervalSinceNow:100];
        [[[mockVenmo stub] andReturn:session] session];
        expect([mockVenmo isSessionValid]).to.beFalsy();
    });

});


describe(@"shouldRefreshToken", ^{

    __block id mockVenmo;
    __block VENSession *session;

    before(^{
        Venmo *venmo = [[Venmo alloc] initWithAppId:@"abcd" secret:@"12345" name:@"fooApp"];
        mockVenmo = [OCMockObject partialMockForObject:venmo];
        session = [[VENSession alloc] init];
    });

    it(@"should return NO if the session is closed", ^{
        session.state = VENSessionStateClosed;
        [[[mockVenmo stub] andReturn:session] session];
        expect([mockVenmo shouldRefreshToken]).to.beFalsy();
    });

    it(@"should return YES if session is open and the token is expired", ^{
        session.state = VENSessionStateOpen;
        session.expirationDate = [NSDate dateWithTimeIntervalSinceNow:-1000];
        [[[mockVenmo stub] andReturn:session] session];
        expect([mockVenmo shouldRefreshToken]).to.beTruthy();
    });

    it(@"should return NO if the session is open and the token is not expired", ^{
        session.state = VENSessionStateOpen;
        session.expirationDate = [NSDate dateWithTimeIntervalSinceNow:10];
        [[[mockVenmo stub] andReturn:session] session];
        expect([mockVenmo shouldRefreshToken]).to.beFalsy();
    });

});


describe(@"refreshTokenWithCompletionHandler:", ^{
    __block Venmo *venmo;
    __block NSString *appId;
    __block NSString *appSecret;

    before(^{
        appId = @"12345";
        appSecret = @"abcdefg";
        venmo = [[Venmo alloc] initWithAppId:appId secret:appSecret name:@"fooapp"];
    });

    it(@"should return an error if the session is closed", ^{
        expect(venmo.session.state).to.equal(VENSessionStateClosed);
        waitUntil(^(DoneCallback done) {
            [venmo refreshTokenWithCompletionHandler:^(NSString *accessToken, BOOL success, NSError *error) {
                expect(accessToken).to.beNil();
                expect(success).to.beFalsy();
                expect(error.code).to.equal(VENSDKErrorSessionNotOpen);
                done();
            }];
        });
    });

    it(@"should call refreshTokenWithAppId:secret:completionHandler: if the session is open", ^{
        NSString *newAccessToken = @"accesstokenbla";
        id mockVENSession = [OCMockObject mockForClass:[VENSession class]];
        [[[mockVENSession stub] andReturn:newAccessToken] accessToken];
        [[[mockVENSession stub] andReturnValue:OCMOCK_VALUE(VENSessionStateOpen)] state];
        [[[mockVENSession stub] andDo:^(NSInvocation *invocation) {
            void(^handler)(NSString *, BOOL, NSError *);
            [invocation getArgument:&handler atIndex:4];
            handler(newAccessToken, YES, nil);
        }] refreshTokenWithAppId:appId secret:appSecret completionHandler:OCMOCK_ANY];

        venmo.session = mockVENSession;
        waitUntil(^(DoneCallback done) {
            [venmo refreshTokenWithCompletionHandler:^(NSString *accessToken, BOOL success, NSError *error) {
                expect(accessToken).to.equal(newAccessToken);
                expect(success).to.beTruthy();
                expect(error).to.beNil();
                done();
            }];
        });
    });
});

#pragma mark - Transactions

describe(@"sendAppSwitchTransactionTo:", ^{

    __block id mockApplication;
    __block id mockSharedApplication;
    __block id mockVenmo;

    before(^{
        // Turn [UIApplication sharedApplication] into a partial mock.
        mockApplication = [OCMockObject niceMockForClass:[UIApplication class]];
        mockSharedApplication = [OCMockObject niceMockForClass:[UIApplication class]];
        [[[mockApplication stub] andReturn:mockSharedApplication] sharedApplication];

        Venmo *venmo = [[Venmo alloc] initWithAppId:@"abcd" secret:@"12345" name:@"fooApp"];
        mockVenmo = [OCMockObject partialMockForObject:venmo];
    });


    it(@"should set self.transactionCompletionHandler to the given completion handler", ^{
        VENTransactionCompletionHandler handler = ^(VENTransaction *transaction, BOOL success, NSError *error) {
            NSUInteger a = 1;
            a++;
        };

        [mockVenmo sendAppSwitchTransactionTo:@"foo"
                              transactionType:VENTransactionTypePay
                                       amount:10
                                         note:@"1234"
                            completionHandler:handler];
        expect(((Venmo *)mockVenmo).transactionCompletionHandler).to.equal(handler);
    });

    it(@"should open the correct URL if isVenmoAppInstalled is true", ^{
        [[[mockVenmo stub] andReturnValue:OCMOCK_VALUE(YES)] isVenmoAppInstalled];

        VENTransactionType type = VENTransactionTypePay;
        NSUInteger amount = 10;
        NSString *note = @"foobarbaz";
        NSString *recipient = @"peter@example.com";
        NSString *expectedPath = [mockVenmo URLPathWithType:type amount:amount note:note recipient:recipient];
        NSURL *expectedURL = [NSURL venmoAppURLWithPath:expectedPath];
        [[mockSharedApplication expect] openURL:expectedURL];
        [mockVenmo sendAppSwitchTransactionTo:recipient
                              transactionType:type
                                       amount:amount
                                         note:note
                            completionHandler:nil];
        [mockSharedApplication verify];
    });

    it(@"should call the completion handler with an error if venmoAppInstalled is false", ^{
        [[[mockVenmo stub] andReturnValue:OCMOCK_VALUE(NO)] isVenmoAppInstalled];
        waitUntil(^(DoneCallback done) {
            [mockVenmo sendAppSwitchTransactionTo:@"ben@example.com"
                                  transactionType:VENTransactionTypePay
                                           amount:10
                                             note:@"foonote"
                                completionHandler:^(VENTransaction *transaction, BOOL success, NSError *error) {
                                    expect(transaction).to.beNil();
                                    expect(success).to.beFalsy();
                                    expect(error.code).to.equal(VENSDKErrorTransactionFailed);
                                    done();
                                }];
        });
    });
});


// Note: This method is just a wrapper around methods in VENCreateTransactionRequest,
// which has good test coverage in VENCore.
describe(@"sendInAppTransactionTo:", ^{

    __block id mockVenmo;
    __block VENSession *session;

    before(^{
        Venmo *venmo = [[Venmo alloc] initWithAppId:@"abcd" secret:@"12345" name:@"fooApp"];
        mockVenmo = [OCMockObject partialMockForObject:venmo];
        session = [[VENSession alloc] init];
    });

    it(@"should call validateAPIRequestWithCompletionHandler", ^{
        [[mockVenmo expect] validateAPIRequestWithCompletionHandler:OCMOCK_ANY];
        [mockVenmo sendAPITransactionTo:@"5555555555"
                          transactionType:VENTransactionTypePay
                                   amount:100
                                     note:@"note"
                                 audience:VENTransactionAudienceFriends
                        completionHandler:nil];
        [session openWithAccessToken:@"token" refreshToken:@"refresh" expiresIn:100 user:nil];
        [mockVenmo verify];
    });

});


// Note: This method decides whether to call sendAPITransactionTo: or sendAppSwitchTransactionTo:
describe(@"sendTransactionTo:", ^{

    __block id mockVenmo;
    __block NSString *recipient;
    __block NSString *note;   
    __block VENTransactionType type;
    __block NSUInteger amount;
    __block VENTransactionAudience audience;
    __block VENTransactionCompletionHandler handler;

    before(^{
        Venmo *venmo = [[Venmo alloc] initWithAppId:@"1234" secret:@"12345" name:@"foobarApp"];
        mockVenmo = [OCMockObject partialMockForObject:venmo];
        recipient = @"foo@venmo.com";
        note = @"notenote";       
        type = VENTransactionTypePay;
        amount = 100;
        audience = VENTransactionAudienceFriends;
        handler = ^(VENTransaction *transaction, BOOL success, NSError *error) {
            int i = 1; i++;
        };       
    });

    it(@"should call sendAPITransaction if defaultTransactionMethod is API", ^{
        [[[mockVenmo stub] andReturnValue:OCMOCK_VALUE(VENTransactionMethodAPI)] defaultTransactionMethod];

        [[mockVenmo expect] sendAPITransactionTo:recipient transactionType:type amount:amount note:note audience:audience completionHandler:handler];

        [mockVenmo sendTransactionTo:recipient transactionType:type amount:amount note:note audience:audience completionHandler:handler];
        [mockVenmo verify];
    });

    it(@"should call sendAppSwitchTransaction if defaultTransactionMethod is app switch", ^{
        [[[mockVenmo stub] andReturnValue:OCMOCK_VALUE(VENTransactionMethodAppSwitch)] defaultTransactionMethod];

        [[mockVenmo expect] sendAppSwitchTransactionTo:recipient transactionType:type amount:amount note:note completionHandler:handler];

        [mockVenmo sendTransactionTo:recipient transactionType:type amount:amount note:note audience:audience completionHandler:handler];
        [mockVenmo verify];
    });

});


describe(@"sendPaymentTo:amount:note:audience:completionHandler:", ^{

    __block id mockVenmo;
    __block NSString *recipient;
    __block NSString *note;
    __block NSUInteger amount;
    __block VENTransactionAudience audience;
    __block VENTransactionCompletionHandler handler;

    before(^{
        Venmo *venmo = [[Venmo alloc] initWithAppId:@"1234" secret:@"12345" name:@"foobarApp"];
        mockVenmo = [OCMockObject partialMockForObject:venmo];
        recipient = @"foo@venmo.com";
        note = @"notenote";
        amount = 100;
        audience = VENTransactionAudienceFriends;
        handler = ^(VENTransaction *transaction, BOOL success, NSError *error) {
            int i = 1; i++;
        };
    });

    it(@"should call sendTransactionTo: with type Pay", ^{
        [[mockVenmo expect] sendTransactionTo:recipient
                              transactionType:VENTransactionTypePay
                                       amount:amount
                                         note:note
                                     audience:audience
                            completionHandler:handler];

        [mockVenmo sendPaymentTo:recipient amount:amount note:note audience:audience completionHandler:handler];

        [mockVenmo verify];
    });
});


describe(@"sendRequestTo:amount:note:audience:completionHandler:", ^{

    __block id mockVenmo;
    __block NSString *recipient;
    __block NSString *note;
    __block NSUInteger amount;
    __block VENTransactionAudience audience;
    __block VENTransactionCompletionHandler handler;

    before(^{
        Venmo *venmo = [[Venmo alloc] initWithAppId:@"1234" secret:@"12345" name:@"foobarApp"];
        mockVenmo = [OCMockObject partialMockForObject:venmo];
        recipient = @"foo@venmo.com";
        note = @"notenote";
        amount = 100;
        audience = VENTransactionAudienceFriends;
        handler = ^(VENTransaction *transaction, BOOL success, NSError *error) {
            int i = 1; i++;
        };
    });

    it(@"should call sendTransactionTo: with type Charge", ^{
        [[mockVenmo expect] sendTransactionTo:recipient
                              transactionType:VENTransactionTypeCharge
                                       amount:amount
                                         note:note
                                     audience:audience
                            completionHandler:handler];

        [mockVenmo sendRequestTo:recipient amount:amount note:note audience:audience completionHandler:handler];
        [mockVenmo verify];
    });
});


describe(@"sendPaymentTo:amount:note:completionHandler:", ^{

    __block id mockVenmo;
    __block NSString *recipient;
    __block NSString *note;
    __block NSUInteger amount;
    __block VENTransactionAudience audience;
    __block VENTransactionCompletionHandler handler;

    before(^{
        Venmo *venmo = [[Venmo alloc] initWithAppId:@"1234" secret:@"12345" name:@"foobarApp"];
        mockVenmo = [OCMockObject partialMockForObject:venmo];
        recipient = @"foo@venmo.com";
        note = @"notenote";
        amount = 100;
        audience = VENTransactionAudienceFriends;
        handler = ^(VENTransaction *transaction, BOOL success, NSError *error) {
            int i = 1; i++;
        };
    });

    it(@"should call sendPaymentTo: with audience set to UserDefault", ^{
        [[mockVenmo expect] sendPaymentTo:recipient
                                   amount:amount
                                     note:note
                                 audience:VENTransactionAudienceUserDefault
                        completionHandler:handler];

        [mockVenmo sendPaymentTo:recipient amount:amount note:note completionHandler:handler];
        [mockVenmo verify];
    });
});


describe(@"sendRequestTo:amount:note:completionHandler:", ^{

    __block id mockVenmo;
    __block NSString *recipient;
    __block NSString *note;
    __block NSUInteger amount;
    __block VENTransactionAudience audience;
    __block VENTransactionCompletionHandler handler;

    before(^{
        Venmo *venmo = [[Venmo alloc] initWithAppId:@"1234" secret:@"12345" name:@"foobarApp"];
        mockVenmo = [OCMockObject partialMockForObject:venmo];
        recipient = @"foo@venmo.com";
        note = @"notenote";
        amount = 100;
        audience = VENTransactionAudienceFriends;
        handler = ^(VENTransaction *transaction, BOOL success, NSError *error) {
            int i = 1; i++;
        };
    });

    it(@"should call sendRequestTo: with audience set to UserDefault", ^{
        [[mockVenmo expect] sendRequestTo:recipient
                                   amount:amount
                                     note:note
                                 audience:VENTransactionAudienceUserDefault
                        completionHandler:handler];

        [mockVenmo sendRequestTo:recipient amount:amount note:note completionHandler:handler];
        [mockVenmo verify];
    });
});


describe(@"validateAPIRequestWithCompletionHandler:", ^{

    __block id mockVenmo;
    __block VENSession *session;

    before(^{
        Venmo *venmo = [[Venmo alloc] initWithAppId:@"abcd" secret:@"12345" name:@"fooApp"];
        mockVenmo = [OCMockObject partialMockForObject:venmo];
        session = [[VENSession alloc] init];
    });

    it(@"should call the completion handler with an error if the session is closed", ^{
        session.state = VENSessionStateClosed;
        [[[mockVenmo stub] andReturn:session] session];
        waitUntil(^(DoneCallback done) {
            [mockVenmo validateAPIRequestWithCompletionHandler:^(id object, BOOL success, NSError *error) {
                expect(object).to.beNil();
                expect(success).to.beFalsy();
                expect(error.code).to.equal(VENSDKErrorSessionNotOpen);
                done();
            }];
        });
    });

    it(@"should call the completion handler with an error if the session's token is expired", ^{
        session.state = VENSessionStateOpen;
        session.expirationDate = [NSDate dateWithTimeIntervalSinceNow:-10];
        [[[mockVenmo stub] andReturn:session] session];
        waitUntil(^(DoneCallback done) {
            [mockVenmo validateAPIRequestWithCompletionHandler:^(id object, BOOL success, NSError *error) {
                expect(object).to.beNil();
                expect(success).to.beFalsy();
                expect(error.code).to.equal(VENSDKErrorAccessTokenExpired);
                done();
            }];
        });
    });

    it(@"should initalize and set VENCore if there is none", ^{
        [VENCore setDefaultCore:nil];
        session.state = VENSessionStateOpen;
        session.accessToken = @"foobaraccess";
        session.expirationDate = [NSDate dateWithTimeIntervalSinceNow:100];
        [[[mockVenmo stub] andReturn:session] session];
        [mockVenmo validateAPIRequestWithCompletionHandler:nil];
        VENCore *defaultCore = [VENCore defaultCore];
        expect(defaultCore).toNot.beNil();
        expect(defaultCore.accessToken).to.equal(session.accessToken);
    });

});

#pragma mark - URLs

describe(@"baseURLPath", ^{

    __block Venmo *venmo;

    beforeEach(^{
        venmo = [[Venmo alloc] initWithAppId:@"foo" secret:@"bar" name:@"Foo Bar App"];
    });

    it(@"should return correct base URL path based on internal development flag.", ^{
        expect([venmo baseURLPath]).to.equal(@"https://api.venmo.com/v1/");
        venmo.internalDevelopment = YES;
        expect([venmo baseURLPath]).to.equal(@"http://api.dev.venmo.com/v1/");
    });
});

describe(@"URLPathWithType:amount:note:recipient:", ^{

    __block Venmo *venmo;
    __block id mockVenmo;
    __block NSString *appId;
    __block NSString *appSecret;
    __block NSString *appName;

    beforeEach(^{
        appId = @"foo";
        appSecret = @"bar";
        appName = @"AppName";

        venmo = [[Venmo alloc] initWithAppId:appId secret:appSecret name:appName];
        mockVenmo = [OCMockObject partialMockForObject:venmo];
        [[[mockVenmo stub] andReturn:@"deviceId"] currentDeviceIdentifier];
    });

    it(@"should return the correct path for a charge", ^{
        NSString *path = [mockVenmo URLPathWithType:VENTransactionTypePay amount:100 note:@"test" recipient:@"cookie"];
        expect([path rangeOfString:@"client=ios"].location).toNot.equal(NSNotFound);
        expect([path rangeOfString:@"app_name=AppName"].location).toNot.equal(NSNotFound);
        expect([path rangeOfString:@"device_id=deviceId"].location).toNot.equal(NSNotFound);
        expect([path rangeOfString:@"amount=1.00"].location).toNot.equal(NSNotFound);
        expect([path rangeOfString:@"txn=pay"].location).toNot.equal(NSNotFound);
        expect([path rangeOfString:@"recipients=cookie"].location).toNot.equal(NSNotFound);
        expect([path rangeOfString:@"note=test"].location).toNot.equal(NSNotFound);
        NSString *versionString = [NSString stringWithFormat:@"app_version=%@", VEN_CURRENT_SDK_VERSION];
        expect([path rangeOfString:versionString].location).toNot.equal(NSNotFound);
    });

    it(@"should return the correct path for a payment", ^{
        NSString *path = [mockVenmo URLPathWithType:VENTransactionTypeCharge amount:9999 note:@"testnote" recipient:@"cookie@venmo.com"];
        expect([path rangeOfString:@"txn=charge"].location).toNot.equal(NSNotFound);
    });
    
});

SpecEnd