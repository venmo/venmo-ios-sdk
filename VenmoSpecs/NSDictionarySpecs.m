#import <Kiwi/Kiwi.h>

#import "NSDictionary+Venmo.h"

SPEC_BEGIN(NSDictionary_VenmoSpec)

describe(@"NSDictionary+Venmo", ^{
    __block NSObject *object;
    __block NSDictionary *dictionary;

    beforeEach(^{
        object = [[NSObject alloc] init];
        dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                      [NSNull null], @"null",
                      object, @"object",
                      @"string", @"string",

                      [NSNumber numberWithBool:YES], @"YES",
                      [NSNumber numberWithBool:NO], @"NO",

                      [NSNumber numberWithInteger:0], @"zero_number",
                      [NSNumber numberWithInteger:1], @"positive_number",
                      [NSNumber numberWithInteger:-1], @"negative_number",

                      [NSDecimalNumber decimalNumberWithString:@"0.0"], @"zero_decimal_number",
                      [NSDecimalNumber decimalNumberWithString:@"3.4"], @"positive_decimal_number",
                      [NSDecimalNumber decimalNumberWithString:@"-3.4"], @"negative_decimal_number",

                      @"0", @"zero_string",
                      @"1", @"positive_integer_string",
                      @"-1", @"negative_integer_string",
                      @"3.56", @"positive_decimal_string",
                      @"-1.34", @"negative_decimal_string",
                      nil];
    });

    describe(@"-objectOrNilForKey:", ^{
        it(@"returns nil for a non-existant key", ^{
            [[dictionary objectOrNilForKey:@"non-existant key"] shouldBeNil];
        });

        it(@"returns nil for [NSNull null]", ^{
            [[dictionary objectOrNilForKey:@"null"] shouldBeNil];
        });

        it(@"returns objectForKey for all other objects", ^{
            [[[dictionary objectOrNilForKey:@"object"] should] beIdenticalTo:object];
        });
    });

    describe(@"-boolForKey:", ^{
        it(@"returns NO for a non-existant key", ^{
            [[theValue([dictionary boolForKey:@"non-existant key"]) should] equal:theValue(NO)];
        });

        it(@"returns NO for [NSNull null]", ^{
            [[theValue([dictionary boolForKey:@"null"]) should] equal:theValue(NO)];
        });

        it(@"returns YES for [NSNumber numberWithBool:YES]", ^{
            [[theValue([dictionary boolForKey:@"YES"]) should] equal:theValue(YES)];
        });

        it(@"returns NO for [NSNumber numberWithBool:NO]", ^{
            [[theValue([dictionary boolForKey:@"NO"]) should] equal:theValue(NO)];
        });

        it(@"returns YES for all other objects", ^{
            [[theValue([dictionary boolForKey:@"object"]) should] equal:theValue(YES)];
        });
    });
});

SPEC_END
