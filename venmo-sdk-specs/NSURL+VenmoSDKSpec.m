#import "Specta.h"
#import "NSURL+VenmoSDK.h"

SpecBegin(NSURL_VenmoSDK)

describe(@"venmoAppURLWithPath:", ^{
    it(@"should return the correct url for the given path", ^{
        NSURL *path = [NSURL venmoAppURLWithPath:@"/path"];
        expect([path absoluteString]).to.equal(@"venmosdk://venmo.com/path");
    });
});

SpecEnd
