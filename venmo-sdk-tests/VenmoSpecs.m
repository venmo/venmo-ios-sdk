#import "Venmo.h"

@interface Venmo (Private)

@property (assign, nonatomic) BOOL internalDevelopment;

- (NSString *)baseURLPath;
- (instancetype)initWithAppId:(NSString *)appId
                       secret:(NSString *)appSecret
                         name:(NSString *)appName;

@end

SpecBegin(Venmo)

describe(@"Internal", ^{

    __block Venmo *venmo;

    beforeEach(^{
        venmo = [[Venmo alloc] initWithAppId:@"foo" secret:@"bar" name:@"Foo Bar App"];
    });

    it(@"should have an internal development flag", ^{
        expect(venmo.internalDevelopment).to.beFalsy();
        venmo.internalDevelopment = YES;
        expect(venmo.internalDevelopment).to.beTruthy();
    });

    it(@"should return correct base URL path based on internal development flag.", ^{
        expect([venmo baseURLPath]).to.equal(@"http://api.venmo.com/v1/");
        venmo.internalDevelopment = YES;
        expect([venmo baseURLPath]).to.equal(@"http://api.devvenmo.com/v1/");
    });

});

SpecEnd