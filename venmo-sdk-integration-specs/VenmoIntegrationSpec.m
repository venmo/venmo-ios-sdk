#import "Specta.h"
#import "Venmo.h"

SpecBegin(VenmoIntegration)

describe(@"startWithAppId:secret:name: and sharedInstance", ^{

    __block NSString *appId = @"foobarbaz";

    afterAll(^{
        [VENSession deleteSessionWithAppId:appId];
    });

    it(@"should create an instance with a cached session", ^{
        NSString *accessToken = @"octocat1234foobar";
        NSString *refreshToken = @"new1234octocatplz";
        NSUInteger expiresIn = 1234;

        VENSession *session = [[VENSession alloc] init];
        NSDictionary *userDictionary = @{VENUserKeyExternalId: @"12345678"};

        VENUser *user = [[VENUser alloc] initWithDictionary:userDictionary];

        [session openWithAccessToken:accessToken refreshToken:refreshToken expiresIn:expiresIn user:user];
        expect(session.state).to.equal(VENSessionStateOpen);

        // save the session
        BOOL saved = [session saveWithAppId:appId];
        expect(saved).to.equal(YES);

        BOOL cachedSessionFound = [Venmo startWithAppId:appId secret:@"foo" name:@"my app"];
        Venmo *sharedVenmo = [Venmo sharedInstance];

        // we should get the formerly saved session
        expect(cachedSessionFound).to.equal(YES);
        expect(sharedVenmo.session.accessToken).to.equal(accessToken);
        expect(sharedVenmo.session.refreshToken).to.equal(refreshToken);
        expect(sharedVenmo.session.user).to.equal(user);
        expect(sharedVenmo.session.state).to.equal(VENSessionStateOpen);
    });

});

describe(@"logout", ^{

    __block NSString *appId;

    it(@"should close the current session and delete the cached session", ^{
        NSString *accessToken = @"octocat1234foobar";
        NSString *refreshToken = @"new1234octocatplz";
        appId = @"12345678";
        NSUInteger expiresIn = 1234;

        id mockVENSession = [OCMockObject niceMockForClass:[VENSession class]];
        [[mockVENSession expect] deleteSessionWithAppId:OCMOCK_ANY];

        VENSession *session = [[VENSession alloc] init];
        VENUser *user = [[VENUser alloc] init];
        [session openWithAccessToken:accessToken refreshToken:refreshToken expiresIn:expiresIn user:user];

        // save the session
        BOOL saved = [session saveWithAppId:appId];
        expect(saved).to.equal(YES);

        [Venmo startWithAppId:appId secret:@"bar" name:@"Foo Bar App"];
        Venmo *venmo = [Venmo sharedInstance];
        expect(venmo.session.state).to.equal(VENSessionStateOpen);
        [venmo logout];

        expect(venmo.session.state).to.equal(VENSessionStateClosed);
        expect(venmo.session.accessToken).to.beNil();
        expect(venmo.session.refreshToken).to.beNil();
        expect(venmo.session.refreshToken).to.beNil();
        expect(venmo.session.user).to.beNil();

        [mockVENSession verify];
    });

});


SpecEnd
