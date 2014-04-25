#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <Specta/Specta.h>

#import "VENPermission.h"

SpecBegin(VENPermission)

describe(@"Initialization", ^{

    it(@"should have unknown type when first initialized", ^{
        VENPermission *permission = [[VENPermission alloc] init];
        expect(permission.type).to.equal(VENPermissionTypeUnknown);
    });

    it(@"should be initalized with specified type", ^{
        VENPermission *permission = [[VENPermission alloc] initWithType:VENPermissionTypeMakePayments];
        expect(permission.type).to.equal(VENPermissionTypeMakePayments);
    });
});

describe(@"Description", ^{

    it(@"should return correct description for VENPermissionTypeAccessFriends", ^{
        VENPermission *permission = [[VENPermission alloc] initWithType:VENPermissionTypeAccessFriends];
        expect([permission displayText]).to.equal(@"access friends");
    });

    it(@"should return correct description for VENPermissionTypeAccessEmail", ^{
        VENPermission *permission = [[VENPermission alloc] initWithType:VENPermissionTypeAccessEmail];
        expect([permission displayText]).to.equal(@"access email");
    });

    it(@"should return correct description for VENPermissionTypeAccessPhone", ^{
        VENPermission *permission = [[VENPermission alloc] initWithType:VENPermissionTypeAccessPhone];
        expect([permission displayText]).to.equal(@"access phone");
    });

    it(@"should return correct description for VENPermissionTypeAccessProfile", ^{
        VENPermission *permission = [[VENPermission alloc] initWithType:VENPermissionTypeAccessProfile];
        expect([permission displayText]).to.equal(@"access profile");
    });

    it(@"should return correct description for VENPermissionTypeAccessBalance", ^{
        VENPermission *permission = [[VENPermission alloc] initWithType:VENPermissionTypeAccessBalance];
        expect([permission displayText]).to.equal(@"access balance");
    });

    it(@"should return correct description for VENPermissionTypeMakePayments", ^{
        VENPermission *permission = [[VENPermission alloc] initWithType:VENPermissionTypeMakePayments];
        expect([permission displayText]).to.equal(@"make payments and charges");
    });

});

describe(@"Name", ^{

    it(@"should return correct name for VENPermissionTypeAccessFriends", ^{
        VENPermission *permission = [[VENPermission alloc] initWithType:VENPermissionTypeAccessFriends];
        expect([permission name]).to.equal(@"access_friends");
    });

    it(@"should return correct name for VENPermissionTypeAccessEmail", ^{
        VENPermission *permission = [[VENPermission alloc] initWithType:VENPermissionTypeAccessEmail];
        expect([permission name]).to.equal(@"access_email");
    });

    it(@"should return correct name for VENPermissionTypeAccessPhone", ^{
        VENPermission *permission = [[VENPermission alloc] initWithType:VENPermissionTypeAccessPhone];
        expect([permission name]).to.equal(@"access_phone");
    });

    it(@"should return correct name for VENPermissionTypeAccessProfile", ^{
        VENPermission *permission = [[VENPermission alloc] initWithType:VENPermissionTypeAccessProfile];
        expect([permission name]).to.equal(@"access_profile");
    });

    it(@"should return correct name for VENPermissionTypeAccessBalance", ^{
        VENPermission *permission = [[VENPermission alloc] initWithType:VENPermissionTypeAccessBalance];
        expect([permission name]).to.equal(@"access_balance");
    });

    it(@"should return correct name for VENPermissionTypeMakePayments", ^{
        VENPermission *permission = [[VENPermission alloc] initWithType:VENPermissionTypeMakePayments];
        expect([permission name]).to.equal(@"make_payments");
    });

});

SpecEnd