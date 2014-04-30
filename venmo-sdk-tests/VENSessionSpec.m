#import "VENSession.h"

SpecBegin(VENSession)

describe(@"Initialization", ^{

    it(@"should initialize with the correct access token and refresh token", ^{
        NSString *accessToken = @"octocat1234foobar";
        NSString *refreshToken = @"new1234octocatplz";
        VENSession *session = [[VENSession alloc] initWithAccessToken:accessToken refreshToken:refreshToken expiresIn:1234];

        expect(session.accessToken).to.equal(accessToken);
        expect(session.refreshToken).to.equal(refreshToken);
    });

    it(@"should initialize with the correct expiration date", ^{
        NSUInteger expiresIn = 1234;
        NSDate *expectedDate = [NSDate date];
        id mockNSDate = [OCMockObject mockForClass:[NSDate class]];
        [[[mockNSDate stub] andReturn:expectedDate] dateWithTimeIntervalSinceNow:expiresIn];
        VENSession *session = [[VENSession alloc] initWithAccessToken:@"1234" refreshToken:@"3456" expiresIn:expiresIn];

        expect(session.expirationDate).to.equal(expectedDate);

        [mockNSDate stopMocking];
    });

});

SpecEnd