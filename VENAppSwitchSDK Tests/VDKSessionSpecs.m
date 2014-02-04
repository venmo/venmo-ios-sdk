#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <Specta/Specta.h>

#import "VDKSession.h"

SpecBegin(VDKSession)

describe(@"Initialization", ^{

    it(@"should initialize with access token, refresh token, and expiration time.", ^{
        NSString *accessToken = @"octocat1234foobar";
        NSString *refreshToken = @"new1234octocatplz";
        NSUInteger expiresIn = 1234;
        VDKSession *session = [[VDKSession alloc] initWithAccessToken:accessToken refreshToken:refreshToken expiresIn:expiresIn];

        expect(session.accessToken).to.equal(accessToken);
        expect(session.refreshToken).to.equal(refreshToken);
        expect(session.expiresIn).to.equal(expiresIn);
    });

});

SpecEnd