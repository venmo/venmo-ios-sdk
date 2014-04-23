#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <Specta/Specta.h>

#import "VenmoSDK.h"

@interface VenmoSDK (Private)

@property (assign, nonatomic) BOOL internalDevelopment;

- (NSString *)baseURLPath;
- (instancetype)initWithAppId:(NSString *)appId
                       secret:(NSString *)appSecret
                         name:(NSString *)appName;

@end

SpecBegin(VenmoSDK)

describe(@"Internal", ^{

    __block VenmoSDK *venmoSDK;

    beforeEach(^{
        venmoSDK = [[VenmoSDK alloc] initWithAppId:@"foo" secret:@"bar" name:@"Foo Bar App"];
    });

    it(@"should have an internal development flag", ^{
        expect(venmoSDK.internalDevelopment).to.beFalsy();
        venmoSDK.internalDevelopment = YES;
        expect(venmoSDK.internalDevelopment).to.beTruthy();
    });

    it(@"should return correct base URL path based on internal development flag.", ^{
        expect([venmoSDK baseURLPath]).to.equal(@"http://api.venmo.com/v1/");
        venmoSDK.internalDevelopment = YES;
        expect([venmoSDK baseURLPath]).to.equal(@"http://api.devvenmo.com/v1/");
    });

});

SpecEnd