#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <Specta/Specta.h>

#import "VENSession.h"

SpecBegin(VENSession)

describe(@"Initialization", ^{

    it(@"should initialize with access token, refresh token, and expiration time.", ^{
        NSString *accessToken = @"octocat1234foobar";
        NSString *refreshToken = @"new1234octocatplz";
        NSUInteger expiresIn = 1234;
        VENSession *session = [[VENSession alloc] initWithAccessToken:accessToken refreshToken:refreshToken expiresIn:expiresIn];

        expect(session.accessToken).to.equal(accessToken);
        expect(session.refreshToken).to.equal(refreshToken);
        expect(session.expiresIn).to.equal(expiresIn);
    });

});

SpecEnd