#import <Kiwi/Kiwi.h>

#import "NSString+Venmo.h"

SPEC_BEGIN(NSString_VenmoSpec)

describe(@"NSString+Venmo", ^{
    __block NSString *string;

    beforeEach(^{
        string = @"string";
    });

    describe(@"-stringValue", ^{
        it(@"returns self", ^{
            [[[string stringValue] should] beIdenticalTo:string];
        });
    });
});

SPEC_END
