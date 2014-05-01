#import "VENSession.h"

#import <SSKeychain/SSKeychainQuery.h>
#import <VENCore/VENCore.h>

extern NSString *const kVENKeychainServiceName;
extern NSString *const kVENKeychainAccountNamePrefix;

@interface VENSession ()

+ (SSKeychainQuery *)keychainQueryWithAppId:(NSString *)appId;

@end

SpecBegin(VENSession)

describe(@"init", ^{
    it(@"should initialize in a closed state", ^{
        VENSession *session = [[VENSession alloc] init];
        expect(session.state).to.equal(VENSessionStateClosed);
    });
});

describe(@"openWithAccessToken:refreshToken:expiresIn:", ^{

    it(@"should set the session state to open", ^{
        VENSession *session = [[VENSession alloc] init];
        expect(session.state).to.equal(VENSessionStateClosed);

        [session openWithAccessToken:@"foo" refreshToken:@"bar" expiresIn:123];
        expect(session.state).to.equal(VENSessionStateOpen);
    });

    it(@"should set the correct access token and refresh token", ^{
        NSString *accessToken = @"octocat1234foobar";
        NSString *refreshToken = @"new1234octocatplz";
        VENSession *session = [[VENSession alloc] init];
        [session openWithAccessToken:accessToken refreshToken:refreshToken expiresIn:123];

        expect(session.accessToken).to.equal(accessToken);
        expect(session.refreshToken).to.equal(refreshToken);
    });

    it(@"should set the correct expiration date", ^{
        NSUInteger expiresIn = 1234;

        // Stub dateWithTimeIntervalSinceNow
        NSDate *expectedDate = [NSDate date];
        id mockNSDate = [OCMockObject mockForClass:[NSDate class]];
        [[[mockNSDate stub] andReturn:expectedDate] dateWithTimeIntervalSinceNow:expiresIn];

        VENSession *session = [[VENSession alloc] init];
        [session openWithAccessToken:@"1234" refreshToken:@"3456" expiresIn:expiresIn];

        expect(session.expirationDate).to.equal(expectedDate);

        [mockNSDate stopMocking];
    });

    it(@"should set the default VENCore instance", ^{
        VENSession *session = [[VENSession alloc] init];
        NSString *accessToken = @"foobarbaz";
        [session openWithAccessToken:accessToken refreshToken:@"3456" expiresIn:123];
        VENCore *core = [VENCore defaultCore];
        expect(core.accessToken).to.equal(accessToken);
    });
});

describe(@"close", ^{

    __block VENSession *session;

    beforeEach(^{
        // open and close a session
        session = [[VENSession alloc] init];
        [session openWithAccessToken:@"foo" refreshToken:@"bar" expiresIn:123];
        expect(session.state).to.equal(VENSessionStateOpen);
        [session close];
    });

    it(@"should delete session state", ^{
        expect(session.accessToken).to.beNil();
        expect(session.refreshToken).to.beNil();
        expect(session.expirationDate).to.beNil();
    });

    it(@"should set the session to closed", ^{
        expect(session.state).to.equal(VENSessionStateClosed);
    });
});

describe(@"keychainQueryWithAppId", ^{

    it(@"should return a query with the correct service name", ^{
        SSKeychainQuery *query = [VENSession keychainQueryWithAppId:@"123"];
        expect(query.service).to.equal(kVENKeychainServiceName);
    });

    it(@"should return a query with the correct account name", ^{
        SSKeychainQuery *query = [VENSession keychainQueryWithAppId:@"123"];
        NSString *expectedAccountName = [NSString stringWithFormat:@"%@123", kVENKeychainAccountNamePrefix];
        expect(query.account).to.equal(expectedAccountName);
    });

});

describe(@"Saving, fetching, and deleting a VENSession", ^{

    it(@"should successfully save, fetch, and delete a session", ^{
        NSString *accessToken = @"octocat1234foobar";
        NSString *refreshToken = @"new1234octocatplz";
        NSUInteger expiresIn = 1234;

        // Stub dateWithTimeIntervalSinceNow
        NSDate *expectedDate = [NSDate date];
        id mockNSDate = [OCMockObject mockForClass:[NSDate class]];
        [[[mockNSDate stub] andReturn:expectedDate] dateWithTimeIntervalSinceNow:expiresIn];

        VENSession *session = [[VENSession alloc] init];
        [session openWithAccessToken:accessToken refreshToken:refreshToken expiresIn:expiresIn];

        // save the session
        BOOL saved = [session saveWithAppId:@"123"];
        expect(saved).to.equal(YES);

        // fetch the session
        VENSession *cachedSession = [VENSession cachedSessionWithAppId:@"123"];
        expect(cachedSession.accessToken).to.equal(accessToken);
        expect(cachedSession.refreshToken).to.equal(refreshToken);
        expect(cachedSession.expirationDate).to.equal(expectedDate);

        // delete the session
        BOOL deleted = [VENSession deleteSessionWithAppId:@"123"];
        expect(deleted).to.equal(YES);

        // try to fetch the session
        VENSession *deletedSession = [VENSession cachedSessionWithAppId:@"123"];
        expect(deletedSession).to.beNil();
    });

});

SpecEnd