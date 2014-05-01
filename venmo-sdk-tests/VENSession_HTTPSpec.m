//
// Separate VENSession tests that involve HTTP stubbing
//

#import "VENSession.h"

SpecBegin(VENSession_HTTP)

fdescribe(@"refreshWithCompletionHandler:", ^{

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
        bodyString = @"{\"refresh_token\":\"currenttoken\",\"client_secret\":\"clientsecret\",\"client_id\":\"12345678\"}";

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

    it(@"should save a new access token when the request succeeds", ^AsyncBlock{
        stubRequest(@"POST", path).
        withBody(bodyString).
        andReturn(200).
        withHeader(@"Content-Type", @"application/json").
        withBody(responseString);

        VENSession *session = [[VENSession alloc] init];
        VENUser *user = [[VENUser alloc] init];
        [session openWithAccessToken:@"abcd" refreshToken:currentRefreshToken expiresIn:1234 user:user];
        [session refreshWithAppId:clientId
                           secret:clientSecret
                completionHandler:^(BOOL success, NSError *error) {
                    expect(success).to.equal(YES);
                    expect(error).to.beNil();

                    // TODO: check that the cached session has the new access token
                    done();
        }];
    });

    it(@"should return an error when the request fails", ^AsyncBlock{
        stubRequest(@"POST", path).
        withBody(bodyString).
        andReturn(400);

        VENSession *session = [[VENSession alloc] init];
        VENUser *user = [[VENUser alloc] init];
        [session openWithAccessToken:@"abcd" refreshToken:currentRefreshToken expiresIn:1234 user:user];
        [session refreshWithAppId:clientId
                           secret:clientSecret
                completionHandler:^(BOOL success, NSError *error) {
                    expect(success).to.equal(NO);

                    // TODO: check that the error is the right type
                    expect(error).toNot.beNil();
                    done();
        }];
    });

});

SpecEnd
