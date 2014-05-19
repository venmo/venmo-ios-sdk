#import "VENSession.h"

SpecBegin(VENSessionIntegration)

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
        NSDictionary *userDictionary = @{VENUserKeyUsername: @"benguo123",
                                         VENUserKeyFirstName: @"Ben",
                                         VENUserKeyLastName: @"Guo",
                                         VENUserKeyDisplayName: @"Ben Guo",
                                         VENUserKeyAbout: @"continuous disintegration",
                                         VENUserKeyPhone: @"4105555555",
                                         VENUserKeyExternalId: @"12345678",
                                         VENUserKeyDateJoined: [NSDate date],
                                         VENUserKeyEmail: @"test@example.com",
                                         VENUserKeyProfileImageUrl: @"http://placekitten.com/300/300"};

        VENUser *user = [[VENUser alloc] initWithDictionary:userDictionary];
        [session openWithAccessToken:accessToken refreshToken:refreshToken expiresIn:expiresIn user:user];

        // save the session
        BOOL saved = [session saveWithAppId:@"123"];
        expect(saved).to.equal(YES);

        // fetch the session
        VENSession *cachedSession = [VENSession cachedSessionWithAppId:@"123"];
        expect(cachedSession.accessToken).to.equal(accessToken);
        expect(cachedSession.refreshToken).to.equal(refreshToken);
        expect(cachedSession.expirationDate).to.equal(expectedDate);
        expect(cachedSession.user).to.equal(user);

        // delete the session
        BOOL deleted = [VENSession deleteSessionWithAppId:@"123"];
        expect(deleted).to.equal(YES);

        // try to fetch the session
        VENSession *deletedSession = [VENSession cachedSessionWithAppId:@"123"];
        expect(deletedSession).to.beNil();
    });

});

SpecEnd
