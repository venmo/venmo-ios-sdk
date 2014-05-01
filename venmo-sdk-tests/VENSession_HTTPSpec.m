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

    beforeAll(^{
        [[LSNocilla sharedInstance] start];
        NSString *baseURL = @"http://api.venmo.com/v1/";
        path = [NSString stringWithFormat:@"%@access_token", baseURL];
        newAccessToken = @"foobar123";
        currentRefreshToken = @"currenttoken";
        newRefreshToken = @"bazbuzz342";
        clientId = @"12345678";
        clientSecret = @"clientsecret";

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

    it(@"should refresh the access token when the request succeeds", ^AsyncBlock{
        stubRequest(@"POST", path).
        withBody(@"{\"refresh_token\":\"currenttoken\",\"client_secret\":\"clientsecret\",\"client_id\":\"12345678\"}").
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
                    done();
        }];
    });

});

SpecEnd
