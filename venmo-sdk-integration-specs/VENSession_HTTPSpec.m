//
// Separate VENSession tests that involve HTTP stubbing
//

#import "VENSession.h"

SpecBegin(VENSession_HTTP)

describe(@"refreshTokenWithAppId:secret:completionHandler:", ^{

    __block NSString *path;
    __block NSString *newAccessToken;
    __block NSString *newRefreshToken;
    __block NSString *currentRefreshToken;
    __block NSString *clientId;
    __block NSString *clientSecret;
    __block NSString *responseString;
    __block NSString *bodyString;

    beforeAll(^{
        [[LSNocilla sharedInstance] start];
        NSString *baseURL = @"http://api.venmo.com/v1/";
        path = [NSString stringWithFormat:@"%@access_token", baseURL];
        newAccessToken = @"foobar123";
        currentRefreshToken = @"currenttoken";
        newRefreshToken = @"bazbuzz342";
        clientId = @"12345678";
        clientSecret = @"clientsecret";
        bodyString = @"{\"client_id\":\"12345678\",\"client_secret\":\"clientsecret\",\"refresh_token\":\"currenttoken\"}";

        // stubbed response
        NSDictionary *responseDict = @{@"access_token" : newAccessToken,
                                       @"refresh_token" : newRefreshToken,
                                       @"expires_in" : @(1234)};
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseDict
                                                           options:0
                                                             error:nil];
        responseString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];       
    });

    afterAll(^{
        [[LSNocilla sharedInstance] stop];
    });

    afterEach(^{
        [[LSNocilla sharedInstance] clearStubs];
    });   

    it(@"should save a new access token when the request succeeds", ^{
        waitUntil(^(DoneCallback done) {
            stubRequest(@"POST", path).
            withBody(bodyString).
            andReturn(200).
            withHeader(@"Content-Type", @"application/json").
            withBody(responseString);

            VENSession *session = [[VENSession alloc] init];
            VENUser *user = [[VENUser alloc] init];
            [session openWithAccessToken:@"abcd" refreshToken:currentRefreshToken expiresIn:1234 user:user];
            NSDate *oldExpirationDate = session.expirationDate;
            [session refreshTokenWithAppId:clientId
                                    secret:clientSecret
                         completionHandler:^(NSString *accessToken, BOOL success, NSError *error) {
                             expect(accessToken).to.equal(newAccessToken);
                             expect(success).to.equal(YES);
                             expect(error).to.beNil();
                             expect(session.state).to.equal(VENSessionStateOpen);
                             expect(session.accessToken).to.equal(newAccessToken);
                             expect(session.refreshToken).to.equal(newRefreshToken);
                             expect([session.expirationDate earlierDate:oldExpirationDate]).to.equal(oldExpirationDate);

                             // The cached session should also be refreshed
                             VENSession *cachedSession = [VENSession cachedSessionWithAppId:clientId];
                             expect(cachedSession.accessToken).to.equal(session.accessToken);
                             expect(cachedSession.refreshToken).to.equal(session.refreshToken);
                             expect(cachedSession.expirationDate).to.equal(session.expirationDate);
                             expect(cachedSession.state).to.equal(session.state);
                             done();
                         }];
        });
    });

    it(@"should return an error when the request fails", ^{
        waitUntil(^(DoneCallback done) {
            stubRequest(@"POST", path).
            withBody(bodyString).
            andReturn(400);

            VENSession *session = [[VENSession alloc] init];
            VENUser *user = [[VENUser alloc] init];
            [session openWithAccessToken:@"abcd" refreshToken:currentRefreshToken expiresIn:1234 user:user];
            [session refreshTokenWithAppId:clientId
                                    secret:clientSecret
                         completionHandler:^(NSString *accessToken, BOOL success, NSError *error) {
                             expect(accessToken).to.beNil();
                             expect(success).to.equal(NO);
                             expect(error.domain).to.equal(VenmoSDKDomain);
                             expect(error.code).to.equal(VENSDKErrorHTTPError);
                             expect(session.state).to.equal(VENSessionStateOpen);
                             done();
                         }];
        });
    });

});

SpecEnd
